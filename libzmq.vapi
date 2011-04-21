/* libzmq.vala
 *
 * Copyright (C) 2011  Lewis Gunsch <lgunsch@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

 *
 * Author:
 *      Lewis Gunsch <lgunsch@gmail.com>
 */

[CCode (lower_case_cprefix = "zmq_", cheader_filename = "zmq.h")]
namespace ZMQ {
	[CCode (cprefix = "ZMQ_")]
	namespace VERSION {
		public const int MAJOR;
		public const int MINOR;
		public const int PATCH;

		[CCode (cname = "ZMQ_VERSION")]
		public const int VERSION;
	}
	
	public static void version (out int major, out int minor, out int patch);
}