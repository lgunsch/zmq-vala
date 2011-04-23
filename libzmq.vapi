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

	/* ZMQ error numbers, in addition to POSIX error numbers. */
	[CCode (cname = "EFSM")]
	public const int EFSM;
	[CCode (cname = "ENOCOMPATPROTO")]
	public const int ENOCOMPATPROTO;
	[CCode (cname = "ETERM")]
	public const int ETERM;
	[CCode (cname = "EMTHREAD")]
	public const int EMTHREAD;

	public int errno ();
	public unowned string strerror (int errnum);

	namespace MSG {
		[CCode (cname = "ZMQ_MAX_VSM_SIZE")]
		public const int MAX_VSM_SIZE;
		[CCode (cname = "ZMQ_DELIMITER")]
		public const int DELIMITER;
		[CCode (cname = "ZMQ_VSM")]
		public const int VSM;
		public const uchar MORE;
		public const uchar SHARED;

		public delegate void free_fn(void* data, void* hint);

		[CCode (cprefix = "zmq_msg_", cname = "zmq_msg_t", destroy_function = "zmq_msg_close", has_copy_function=true)]
		public struct Msg {
			[CCode (cname = "zmq_msg_init")]
			public Msg();
			[CCode (cname = "zmq_msg_init_size")]
			public Msg.size(size_t size);
			[CCode (cname = "zmq_msg_init_data")]
			public Msg.data(void *data, size_t size, free_fn *ffn, void *hint);
		}

		public int move(Msg dest, Msg src);
	}
}