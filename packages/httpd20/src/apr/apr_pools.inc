{ Copyright 2000-2005 The Apache Software Foundation or its licensors, as
 * applicable.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 }

{
 * @file apr_pools.h
 * @brief APR memory allocation
 *
 * Resource allocation routines...
 *
 * designed so that we don't have to keep track of EVERYTHING so that
 * it can be explicitly freed later (a fundamentally unsound strategy ---
 * particularly in the presence of die()).
 *
 * Instead, we maintain pools, and allocate items (both memory and I/O
 * handlers) from the pools --- currently there are two, one for per
 * transaction info, and one for config info.  When a transaction is over,
 * we can delete everything in the per-transaction apr_pool_t without fear,
 * and without thinking too hard about it either.
 }

{#include "apr.h"
#include "apr_errno.h"
#include "apr_general.h"{ { for APR_STRINGIFY }
//#include "apr_want.h"

{
 * @defgroup apr_pools Memory Pool Functions
 * @ingroup APR
 * @
 }

{ The fundamental pool type }
type
  apr_pool_t = record end;
  Papr_pool_t = ^apr_pool_t;
  PPapr_pool_t = ^Papr_pool_t;

{
 * Declaration helper macro to construct apr_foo_pool_get()s.
 *
 * This standardized macro is used by opaque (APR) data types to return
 * the apr_pool_t that is associated with the data type.
 *
 * APR_POOL_DECLARE_ACCESSOR() is used in a header file to declare the
 * accessor function. A typical usage and result would be:
 * <pre>
 *    APR_POOL_DECLARE_ACCESSOR(file);
 * becomes:
 *    APR_DECLARE(apr_pool_t *) apr_file_pool_get(apr_file_t *ob);
 * </pre>
 * @remark Doxygen unwraps this macro (via doxygen.conf) to provide
 * actual help for each specific occurance of apr_foo_pool_get.
 * @remark the linkage is specified for APR. It would be possible to expand
 *       the macros to support other linkages.
 }
{#define APR_POOL_DECLARE_ACCESSOR(type) \
    APR_DECLARE(apr_pool_t *) apr_##type##_pool_get \
        (const apr_##type##_t *the##type)
}
{
 * Implementation helper macro to provide apr_foo_pool_get()s.
 *
 * In the implementation, the APR_POOL_IMPLEMENT_ACCESSOR() is used to
 * actually define the function. It assumes the field is named "pool".
 }
{#define APR_POOL_IMPLEMENT_ACCESSOR(type) \
    APR_DECLARE(apr_pool_t *) apr_##type##_pool_get \
            (const apr_##type##_t *the##type) \}
        { return the##type->pool; }


{
 * Pool debug levels
 *
 * <pre>
 * | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
 * ---------------------------------
 * |   |   |   |   |   |   |   | x |  General debug code enabled (usefull in
 *                                    combination with --with-efence).
 *
 * |   |   |   |   |   |   | x |   |  Verbose output on stderr (report
 *                                    CREATE, CLEAR, DESTROY).
 *
 * |   |   |   | x |   |   |   |   |  Verbose output on stderr (report
 *                                    PALLOC, PCALLOC).
 *
 * |   |   |   |   |   | x |   |   |  Lifetime checking. On each use of a
 *                                    pool, check its lifetime.  If the pool
 *                                    is out of scope, abort().
 *                                    In combination with the verbose flag
 *                                    above, it will output LIFE in such an
 *                                    event prior to aborting.
 *
 * |   |   |   |   | x |   |   |   |  Pool owner checking.  On each use of a
 *                                    pool, check if the current thread is the
 *                                    pools owner.  If not, abort().  In
 *                                    combination with the verbose flag above,
 *                                    it will output OWNER in such an event
 *                                    prior to aborting.  Use the debug
 *                                    function apr_pool_owner_set() to switch
 *                                    a pools ownership.
 *
 * When no debug level was specified, assume general debug mode.
 * If level 0 was specified, debugging is switched off
 * </pre>
 }
{#if defined(APR_POOL_DEBUG)
#if (APR_POOL_DEBUG != 0) && (APR_POOL_DEBUG - 0 == 0)
#undef APR_POOL_DEBUG
#define APR_POOL_DEBUG 1
#endif
#else
#define APR_POOL_DEBUG 0
#endif
}
{ the place in the code where the particular function was called }
//#define APR_POOL__FILE_LINE__ __FILE__ ":" APR_STRINGIFY(__LINE__)



{ A function that is called when allocation fails. }
type
  apr_abortfunc_t = function (retcode: Integer): Integer;

{
 * APR memory structure manipulators (pools, tables, and arrays).
 }

{
 * Initialization
 }

{
 * Setup all of the internal structures required to use pools
 * @remark Programs do NOT need to call this directly.  APR will call this
 *      automatically from apr_initialize.
 * @internal
 }
function apr_pool_initialize: apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_initialize' + LibSuff0;

{
 * Tear down all of the internal structures required to use pools
 * @remark Programs do NOT need to call this directly.  APR will call this
 *      automatically from apr_terminate.
 * @internal
 }
procedure apr_pool_terminate;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_terminate' + LibSuff0;

{
 * Pool creation/destruction
 }

{$include apr_allocator.inc}

{
 * Create a new pool.
 * @param newpool The pool we have just created.
 * @param parent The parent pool.  If this is NULL, the new pool is a root
 *        pool.  If it is non-NULL, the new pool will inherit all
 *        of its parent pool's attributes, except the apr_pool_t will
 *        be a sub-pool.
 * @param abort_fn A function to use if the pool cannot allocate more memory.
 * @param allocator The allocator to use with the new pool.  If NULL the
 *        allocator of the parent pool will be used.
 }
function apr_pool_create_ex(newpool: PPapr_pool_t;
 parent: Papr_pool_t; abort_fn: apr_abortfunc_t;
 allocator: Papr_allocator_t): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_create_ex' + LibSuff16;

{
 * Debug version of apr_pool_create_ex.
 * @param newpool @see apr_pool_create.
 * @param parent @see apr_pool_create.
 * @param abort_fn @see apr_pool_create.
 * @param allocator @see apr_pool_create.
 * @param file_line Where the function is called from.
 *        This is usually APR_POOL__FILE_LINE__.
 * @remark Only available when APR_POOL_DEBUG is defined.
 *         Call this directly if you have you apr_pool_create_ex
 *         calls in a wrapper function and wish to override
 *         the file_line argument to reflect the caller of
 *         your wrapper function.  If you do not have
 *         apr_pool_create_ex in a wrapper, trust the macro
 *         and don't call apr_pool_create_ex_debug directly.
 }
function apr_pool_create_ex_debug(newpool: PPapr_pool_t;
 parent: Papr_pool_t; abort_fn: apr_abortfunc_t;
 allocator: Papr_allocator_t; const file_line: PChar): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_create_ex_debug' + LibSuff20;

{#if APR_POOL_DEBUG
#define apr_pool_create_ex(newpool, parent, abort_fn, allocator)  \
    apr_pool_create_ex_debug(newpool, parent, abort_fn, allocator, \
                             APR_POOL__FILE_LINE__)
#endif
}
{
 * Create a new pool.
 * @param newpool The pool we have just created.
 * @param parent The parent pool.  If this is NULL, the new pool is a root
 *        pool.  If it is non-NULL, the new pool will inherit all
 *        of its parent pool's attributes, except the apr_pool_t will
 *        be a sub-pool.
 }
{$ifdef DOXYGEN}
function apr_pool_create(newpool: PPapr_pool_t;
 parent: Papr_pool_t): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_create' + LibSuff8;
{$else}
{.$ifdef APR_POOL_DEBUG}
{#define apr_pool_create(newpool, parent) \
    apr_pool_create_ex_debug(newpool, parent, NULL, NULL, \
                             APR_POOL__FILE_LINE__)}
{.$else}
function apr_pool_create(newpool: PPapr_pool_t; parent: Papr_pool_t): apr_status_t;
{.$endif}
{$endif}

{ @deprecated @see apr_pool_create_ex }
{#if APR_POOL_DEBUG
#define apr_pool_sub_make(newpool, parent, abort_fn) \
    (void)apr_pool_create_ex_debug(newpool, parent, abort_fn, \
                                   NULL, \
                                   APR_POOL__FILE_LINE__)
#else}
function apr_pool_sub_make(newpool: PPapr_pool_t; parent: Papr_pool_t;
 abort_fn: apr_abortfunc_t): apr_status_t;
//#endif

{
 * Find the pools allocator
 * @param pool The pool to get the allocator from.
 }
function apr_pool_allocator_get(pool: Papr_pool_t): Papr_allocator_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_allocator_get' + LibSuff4;

{
 * Clear all memory in the pool and run all the cleanups. This also destroys all
 * subpools.
 * @param p The pool to clear
 * @remark This does not actually free the memory, it just allows the pool
 *         to re-use this memory for the next allocation.
 * @see apr_pool_destroy()
 }
procedure apr_pool_clear(p: Papr_pool_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_clear' + LibSuff4;

{
 * Debug version of apr_pool_clear.
 * @param p See: apr_pool_clear.
 * @param file_line Where the function is called from.
 *        This is usually APR_POOL__FILE_LINE__.
 * @remark Only available when APR_POOL_DEBUG is defined.
 *         Call this directly if you have you apr_pool_clear
 *         calls in a wrapper function and wish to override
 *         the file_line argument to reflect the caller of
 *         your wrapper function.  If you do not have
 *         apr_pool_clear in a wrapper, trust the macro
 *         and don't call apr_pool_destroy_clear directly.
 }
procedure apr_pool_clear_debug(p: Papr_pool_t; const file_line: PChar);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_clear_debug' + LibSuff8;

{#if APR_POOL_DEBUG
#define apr_pool_clear(p) \
    apr_pool_clear_debug(p, APR_POOL__FILE_LINE__)
#endif}

{
 * Destroy the pool. This takes similar action as apr_pool_clear() and then
 * frees all the memory.
 * @param p The pool to destroy
 * @remark This will actually free the memory
 }
procedure apr_pool_destroy(p: Papr_pool_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_destroy' + LibSuff4;

{
 * Debug version of apr_pool_destroy.
 * @param p See: apr_pool_destroy.
 * @param file_line Where the function is called from.
 *        This is usually APR_POOL__FILE_LINE__.
 * @remark Only available when APR_POOL_DEBUG is defined.
 *         Call this directly if you have you apr_pool_destroy
 *         calls in a wrapper function and wish to override
 *         the file_line argument to reflect the caller of
 *         your wrapper function.  If you do not have
 *         apr_pool_destroy in a wrapper, trust the macro
 *         and don't call apr_pool_destroy_debug directly.
 }
procedure apr_pool_destroy_debug(p: Papr_pool_t; const file_line: PChar);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_destroy_debug' + LibSuff8;

{#if APR_POOL_DEBUG
#define apr_pool_destroy(p) \
    apr_pool_destroy_debug(p, APR_POOL__FILE_LINE__)
#endif}


{
 * Memory allocation
 }

{
 * Allocate a block of memory from a pool
 * @param p The pool to allocate from
 * @param size The amount of memory to allocate
 * @return The allocated memory
 }
function apr_palloc(p: Papr_pool_t; size: apr_size_t): Pointer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_palloc' + LibSuff8;

{
 * Debug version of apr_palloc
 * @param p See: apr_palloc
 * @param size See: apr_palloc
 * @param file_line Where the function is called from.
 *        This is usually APR_POOL__FILE_LINE__.
 * @return See: apr_palloc
 }
function apr_palloc_debug(p: Papr_pool_t; size: apr_size_t;
 const file_line: PChar): Pointer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_palloc_debug' + LibSuff12;

{#if APR_POOL_DEBUG
#define apr_palloc(p, size) \
    apr_palloc_debug(p, size, APR_POOL__FILE_LINE__)
#endif
}
{
 * Allocate a block of memory from a pool and set all of the memory to 0
 * @param p The pool to allocate from
 * @param size The amount of memory to allocate
 * @return The allocated memory
 }
{#if defined(DOXYGEN)}

function apr_pcalloc(p: Papr_pool_t; size: apr_size_t): Pointer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pcalloc' + LibSuff8;

{#elif !APR_POOL_DEBUG
#define apr_pcalloc(p, size) memset(apr_palloc(p, size), 0, size)
#endif
}
{
 * Debug version of apr_pcalloc
 * @param p See: apr_pcalloc
 * @param size See: apr_pcalloc
 * @param file_line Where the function is called from.
 *        This is usually APR_POOL__FILE_LINE__.
 * @return See: apr_pcalloc
 }
{APR_DECLARE(void *) apr_pcalloc_debug(apr_pool_t *p, apr_size_t size,
                                      const char *file_line);

#if APR_POOL_DEBUG
#define apr_pcalloc(p, size) \
    apr_pcalloc_debug(p, size, APR_POOL__FILE_LINE__)
#endif

}
{
 * Pool Properties
 }

{
 * Set the function to be called when an allocation failure occurs.
 * @remark If the program wants APR to exit on a memory allocation error,
 *      then this function can be called to set the callback to use (for
 *      performing cleanup and then exiting). If this function is not called,
 *      then APR will return an error and expect the calling program to
 *      deal with the error accordingly.
 }
procedure apr_pool_abort_set(abortfunc: apr_abortfunc_t; pool: Papr_pool_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_abort_set' + LibSuff8;

{ @deprecated @see apr_pool_abort_set }
{APR_DECLARE(void) apr_pool_set_abort(apr_abortfunc_t abortfunc,
                                     apr_pool_t *pool);
}
{
 * Get the abort function associated with the specified pool.
 * @param pool The pool for retrieving the abort function.
 * @return The abort function for the given pool.
 }
function apr_pool_abort_get(pool: Papr_pool_t): apr_abortfunc_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_abort_get' + LibSuff4;

{ @deprecated @see apr_pool_abort_get }
//APR_DECLARE(apr_abortfunc_t) apr_pool_get_abort(apr_pool_t *pool);

{
 * Get the parent pool of the specified pool.
 * @param pool The pool for retrieving the parent pool.
 * @return The parent of the given pool.
 }
function apr_pool_parent_get(pool: Papr_pool_t): Papr_pool_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_parent_get' + LibSuff4;

{ @deprecated @see apr_pool_parent_get }
//APR_DECLARE(apr_pool_t *) apr_pool_get_parent(apr_pool_t *pool);

{
 * Determine if pool a is an ancestor of pool b
 * @param a The pool to search
 * @param b The pool to search for
 * @return True if a is an ancestor of b, NULL is considered an ancestor
 *         of all pools.
 }
function apr_pool_is_ancestor(a, b: Papr_pool_t): Integer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_is_ancestor' + LibSuff8;

{
 * Tag a pool (give it a name)
 * @param pool The pool to tag
 * @param tag  The tag
 }
procedure apr_pool_tag(pool: Papr_pool_t; tag: PChar);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_tag' + LibSuff8;

{
 * User data management
 }

{
 * Set the data associated with the current pool
 * @param data The user data associated with the pool.
 * @param key The key to use for association
 * @param cleanup The cleanup program to use to cleanup the data (NULL if none)
 * @param pool The current pool
 * @warning The data to be attached to the pool should have a life span
 *          at least as long as the pool it is being attached to.
 *
 *      Users of APR must take EXTREME care when choosing a key to
 *      use for their data.  It is possible to accidentally overwrite
 *      data by choosing a key that another part of the program is using.
 *      Therefore it is advised that steps are taken to ensure that unique
 *      keys are used for all of the userdata objects in a particular pool
 *      (the same key in two different pools or a pool and one of its
 *      subpools is okay) at all times.  Careful namespace prefixing of
 *      key names is a typical way to help ensure this uniqueness.
 }
//function apr_pool_userdata_set(
// const data: Pointer; const key: PChar;
// cleanup: function(param: Pointer): apr_status_t,
// pool: Papr_pool_t): apr_status_t;
// {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
// external LibAPR name LibNamePrefix + 'apr_pool_userdata_set' + LibSuff20;

{
 * Set the data associated with the current pool
 * @param data The user data associated with the pool.
 * @param key The key to use for association
 * @param cleanup The cleanup program to use to cleanup the data (NULL if none)
 * @param pool The current pool
 * @note same as apr_pool_userdata_set(), except that this version doesn't
 *       make a copy of the key (this function is useful, for example, when
 *       the key is a string literal)
 * @warning This should NOT be used if the key could change addresses by
 *       any means between the apr_pool_userdata_setn() call and a
 *       subsequent apr_pool_userdata_get() on that key, such as if a
 *       static string is used as a userdata key in a DSO and the DSO could
 *       be unloaded and reloaded between the _setn() and the _get().  You
 *       MUST use apr_pool_userdata_set() in such cases.
 * @warning More generally, the key and the data to be attached to the
 *       pool should have a life span at least as long as the pool itself.
 *
 }
//function apr_pool_userdata_setn(
// const data: Pointer; const key: PChar;
// cleanup: function(param: Pointer): apr_status_t,
// pool: Papr_pool_t): apr_status_t;
// {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
// external LibAPR name LibNamePrefix + 'apr_pool_userdata_setn' + LibSuff20;

{
 * Return the data associated with the current pool.
 * @param data The user data associated with the pool.
 * @param key The key for the data to retrieve
 * @param pool The current pool.
 }
function apr_pool_userdata_get(data: PPointer; const key: PChar;
 pool: Papr_pool_t): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_userdata_get' + LibSuff12;

{
 * Cleanup
 *
 * Cleanups are performed in the reverse order they were registered.  That is:
 * Last In, First Out.
 }

{
 * Register a function to be called when a pool is cleared or destroyed
 * @param p The pool register the cleanup with
 * @param data The data to pass to the cleanup function.
 * @param plain_cleanup The function to call when the pool is cleared
 *                      or destroyed
 * @param child_cleanup The function to call when a child process is being
 *                      shutdown - this function is called in the child, obviously!
 }
type
  plain_cleanup_t = function(param: Pointer): apr_status_t; cdecl;
  child_cleanup_t = function(param: Pointer): apr_status_t; cdecl;
  
procedure apr_pool_cleanup_register(p: Papr_pool_t;
 const data: Pointer;
 plain_cleanup: plain_cleanup_t;
 child_cleanup: child_cleanup_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_cleanup_register' + LibSuff16;

{
 * Remove a previously registered cleanup function
 * @param p The pool remove the cleanup from
 * @param data The data to remove from cleanup
 * @param cleanup The function to remove from cleanup
 * @remarks For some strange reason only the plain_cleanup is handled by this
 *          function
 }
//procedure  apr_pool_cleanup_for_exec;
// {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
// external LibAPR name LibNamePrefix + 'apr_pool_cleanup_for_exec' + LibSuff0;

//APR_DECLARE(void) apr_pool_cleanup_kill(apr_pool_t *p, const void *data,
//                                        apr_status_t cleanup)(void );

{
 * Replace the child cleanup of a previously registered cleanup
 * @param p The pool of the registered cleanup
 * @param data The data of the registered cleanup
 * @param plain_cleanup The plain cleanup function of the registered cleanup
 * @param child_cleanup The function to register as the child cleanup
 }
//procedure  apr_pool_cleanup_for_exec;
// {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
// external LibAPR name LibNamePrefix + 'apr_pool_cleanup_for_exec' + LibSuff0;

{APR_DECLARE(void) apr_pool_child_cleanup_set(
    apr_pool_t *p,
    const void *data,
    apr_status_t plain_cleanup)(void ,
    apr_status_t child_cleanup)(void );
}
{
 * Run the specified cleanup function immediately and unregister it. Use
 * @a data instead of the data that was registered with the cleanup.
 * @param p The pool remove the cleanup from
 * @param data The data to remove from cleanup
 * @param cleanup The function to remove from cleanup
 }
//procedure  apr_pool_cleanup_for_exec;
// {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
// external LibAPR name LibNamePrefix + 'apr_pool_cleanup_for_exec' + LibSuff0;

{APR_DECLARE(apr_status_t) apr_pool_cleanup_run(
    apr_pool_t *p,
    void *data,
    apr_status_t cleanup)(void );}

{
 * An empty cleanup function
 * @param data The data to cleanup
 }
//APR_DECLARE_NONSTD(apr_status_t) apr_pool_cleanup_null(void *data);

{ Preparing for exec() --- close files, etc., but *don't* flush I/O
 * buffers, *don't* wait for subprocesses, and *don't* free any memory.
 }
{
 * Run all of the child_cleanups, so that any unnecessary files are
 * closed because we are about to exec a new program
 }
procedure  apr_pool_cleanup_for_exec;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_cleanup_for_exec' + LibSuff0;

{
 * @defgroup PoolDebug Pool Debugging functions.
 *
 * pools have nested lifetimes -- sub_pools are destroyed when the
 * parent pool is cleared.  We allow certain liberties with operations
 * on things such as tables (and on other structures in a more general
 * sense) where we allow the caller to insert values into a table which
 * were not allocated from the table's pool.  The table's data will
 * remain valid as long as all the pools from which its values are
 * allocated remain valid.
 *
 * For example, if B is a sub pool of A, and you build a table T in
 * pool B, then it's safe to insert data allocated in A or B into T
 * (because B lives at most as long as A does, and T is destroyed when
 * B is cleared/destroyed).  On the other hand, if S is a table in
 * pool A, it is safe to insert data allocated in A into S, but it
 * is *not safe* to insert data allocated from B into S... because
 * B can be cleared/destroyed before A is (which would leave dangling
 * pointers in T's data structures).
 *
 * In general we say that it is safe to insert data into a table T
 * if the data is allocated in any ancestor of T's pool.  This is the
 * basis on which the APR_POOL_DEBUG code works -- it tests these ancestor
 * relationships for all data inserted into tables.  APR_POOL_DEBUG also
 * provides tools (apr_pool_find, and apr_pool_is_ancestor) for other
 * folks to implement similar restrictions for their own data
 * structures.
 *
 * However, sometimes this ancestor requirement is inconvenient --
 * sometimes we're forced to create a sub pool (such as through
 * apr_sub_req_lookup_uri), and the sub pool is guaranteed to have
 * the same lifetime as the parent pool.  This is a guarantee implemented
 * by the *caller*, not by the pool code.  That is, the caller guarantees
 * they won't destroy the sub pool individually prior to destroying the
 * parent pool.
 *
 * In this case the caller must call apr_pool_join() to indicate this
 * guarantee to the APR_POOL_DEBUG code.  There are a few examples spread
 * through the standard modules.
 *
 * These functions are only implemented when #APR_POOL_DEBUG is set.
 *
 }
{$if defined(APR_POOL_DEBUG) or defined(DOXYGEN)}
{
 * Guarantee that a subpool has the same lifetime as the parent.
 * @param p The parent pool
 * @param sub The subpool
 }
procedure  apr_pool_join(p, sub: Papr_pool_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_join' + LibSuff8;

{
 * Find a pool from something allocated in it.
 * @param mem The thing allocated in the pool
 * @return The pool it is allocated in
 }
function apr_pool_find(const mem: Pointer): Papr_pool_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_find' + LibSuff4;

{
 * Report the number of bytes currently in the pool
 * @param p The pool to inspect
 * @param recurse Recurse/include the subpools' sizes
 * @return The number of bytes
 }
function apr_pool_num_bytes(p: Papr_pool_t; recurse: Integer): apr_size_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_num_bytes' + LibSuff8;

{
 * Lock a pool
 * @param pool The pool to lock
 * @param flag  The flag
 }
procedure  apr_pool_lock(pool: Papr_pool_t; flag: Integer);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibAPR name LibNamePrefix + 'apr_pool_lock' + LibSuff8;

{$else} { APR_POOL_DEBUG or DOXYGEN }

{#ifdef apr_pool_join
#undef apr_pool_join
#endif
#define apr_pool_join(a,b)

#ifdef apr_pool_lock
#undef apr_pool_lock
#endif
#define apr_pool_lock(pool, lock)}

{$endif} { APR_POOL_DEBUG or DOXYGEN }

