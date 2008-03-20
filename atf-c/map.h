/*
 * Automated Testing Framework (atf)
 *
 * Copyright (c) 2008 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *        This product includes software developed by the NetBSD
 *        Foundation, Inc. and its contributors.
 * 4. Neither the name of The NetBSD Foundation nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if !defined(ATF_C_MAP_H)
#define ATF_C_MAP_H

#include <stdarg.h>
#include <stdbool.h>

#include <atf-c/error.h>
#include <atf-c/list.h>
#include <atf-c/object.h>

/* ---------------------------------------------------------------------
 * The "atf_map_citer" type.
 * --------------------------------------------------------------------- */

struct atf_map_citer {
    const struct atf_map *m_map;
    const void *m_entry;
};
typedef struct atf_map_citer atf_map_citer_t;

/* Getters. */
const void *atf_map_citer_data(const atf_map_citer_t);

/* Operators. */
bool atf_equal_map_citer_map_citer(const atf_map_citer_t,
                                   const atf_map_citer_t);

/* ---------------------------------------------------------------------
 * The "atf_map_iter" type.
 * --------------------------------------------------------------------- */

struct atf_map_iter {
    struct atf_map *m_map;
    void *m_entry;
};
typedef struct atf_map_iter atf_map_iter_t;

/* Getters. */
void *atf_map_iter_data(const atf_map_iter_t);

/* Operators. */
bool atf_equal_map_iter_map_iter(const atf_map_iter_t,
                                 const atf_map_iter_t);

/* ---------------------------------------------------------------------
 * The "atf_map" type.
 * --------------------------------------------------------------------- */

/* A list-based map.  Typically very inefficient, but our maps are small
 * enough. */
struct atf_map {
    atf_object_t m_object;

    atf_list_t m_list;
};
typedef struct atf_map atf_map_t;

/* Constructors and destructors */
atf_error_t atf_map_init(atf_map_t *);
void atf_map_fini(atf_map_t *);

/* Getters. */
atf_map_iter_t atf_map_end(atf_map_t *);
atf_map_citer_t atf_map_end_c(const atf_map_t *);
atf_map_iter_t atf_map_find(atf_map_t *, const char *);
atf_map_citer_t atf_map_find_c(const atf_map_t *, const char *);
size_t atf_map_size(const atf_map_t *);

/* Modifiers. */
atf_error_t atf_map_insert(atf_map_t *, const char *, void *, bool);

#endif /* ATF_C_MAP_H */
