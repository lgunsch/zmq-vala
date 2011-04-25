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
	[Compact]
	[CCode (cprefix = "zmq_", cname = "void", free_function = "zmq_term")]
	public class Context {
		[CCode (cname = "zmq_init")]
		public Context (int io_threads);
	}

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

		/* does not work correctly yet. Using GLib.Func for now.
		 * [CCode (cname = "zmq_free_fn")]
		 * public delegate void free_fn(u data, void* hint);
		 */

		[CCode (cprefix = "zmq_msg_", cname = "zmq_msg_t", destroy_function = "zmq_msg_close", has_copy_function=true)]
		public struct Msg {
			[CCode (cname = "zmq_msg_init")]
			public Msg();
			[CCode (cname = "zmq_msg_init_size")]
			public Msg.size(size_t size);
			[CCode (cname = "zmq_msg_init_data")]
			public Msg.data(uint8[] data, GLib.Func? ffn = null);
		}

		public int move(Msg dest, Msg src);
	}

	[CCode (cname = "int", cprefix = "ZMQ_")]
	public enum SocketType {
		PAIR,
		PUB,
		SUB,
		REQ,
		REP,
		DEALER,
		ROUTER,
		PULL,
		PUSH,
		XPUB,
		XSUB
	}
	
	[CCode (cname = "int", cprefix = "ZMQ_")]
	public enum SocketOption {
		HWM,
		SWAP,
		AFFINITY,
		IDENTITY,
		SUBSCRIBE,
		UNSUBSCRIBE,
		RATE,
		RECOVERY_IVL,
		MCAST_LOOP,
		SNDBUF,
		RCVBUF,
		RCVMORE,
		FD,
		EVENTS,
		TYPE,
		LINGER,
		RECONNECT_IVL,
		BACKLOG,
		RECOVERY_IVL_MSEC,
		RECONNECT_IVL_MAX
	}

	[CCode (cname = "int", cprefix = "ZMQ_")]
	public enum SendRecvOption {
		NOBLOCK,
		SNDMORE
	}

	[Compact]
	[CCode (cprefix = "zmq_", cname = "void", free_function = "zmq_close")]
	public class Socket {
		/* how do we deal with errno return in constructor ? */
		[CCode (cname = "zmq_socket")]
		public Socket (Context context, SocketType type);
		[CCode (simple_generics = true)]
		public int setsockopt < T > (SocketOption option, T optval, size_t optvallen); 
		[CCode (simple_generics = true)]
		public int getsockopt < T > (SocketOption option, T optval, size_t optvallen);
		public int bind (string addr);
		public int connect (string addr);
		public int send (MSG.Msg msg, SendRecvOption flags);
		public int recv (MSG.Msg msg, SendRecvOption flags);
	}
}