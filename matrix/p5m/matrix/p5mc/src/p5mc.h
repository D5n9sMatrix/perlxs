/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * p5mc.h
 * Copyright (C) 2021 denis <denis@denis-Inspiron-15-3567>
 * 
 * p5mc is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * p5mc is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _P5MC_
#define _P5MC_

#include <gtk/gtk.h>

G_BEGIN_DECLS

#define P5MC_TYPE_APPLICATION             (p5mc_get_type ())
#define P5MC_APPLICATION(obj)             (G_TYPE_CHECK_INSTANCE_CAST ((obj), P5MC_TYPE_APPLICATION, P5mc))
#define P5MC_APPLICATION_CLASS(klass)     (G_TYPE_CHECK_CLASS_CAST ((klass), P5MC_TYPE_APPLICATION, P5mcClass))
#define P5MC_IS_APPLICATION(obj)          (G_TYPE_CHECK_INSTANCE_TYPE ((obj), P5MC_TYPE_APPLICATION))
#define P5MC_IS_APPLICATION_CLASS(klass)  (G_TYPE_CHECK_CLASS_TYPE ((klass), P5MC_TYPE_APPLICATION))
#define P5MC_APPLICATION_GET_CLASS(obj)   (G_TYPE_INSTANCE_GET_CLASS ((obj), P5MC_TYPE_APPLICATION, P5mcClass))

typedef struct _P5mcClass P5mcClass;
typedef struct _P5mc P5mc;
typedef struct _P5mcPrivate P5mcPrivate;

struct _P5mcClass
{
	GtkApplicationClass parent_class;
};

struct _P5mc
{
	GtkApplication parent_instance;

	P5mcPrivate *priv;

};

GType p5mc_get_type (void) G_GNUC_CONST;
P5mc *p5mc_new (void);

/* Callbacks */

G_END_DECLS

#endif /* _APPLICATION_H_ */

