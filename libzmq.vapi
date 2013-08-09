/* libzmq.vala
 *
 * Copyright (C) 2011  Lewis Gunsch <lewis@gunsch.ca>
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
 *      Lewis Gunsch <lewis@gunsch.ca>
 *      Geoff Johnson <geoff.jay@gmail.com>
 */

[CCode (lower_case_cprefix = "zmq_", cheader_filename = "zmq.h")]
namespace ZMQ {

    [CCode (cprefix = "ZMQ_")]
    namespace Version {
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

    /* New API */
    /* Context options */
    [CCode (cname = "ZMQ_IO_THREADS")]
    public const int IO_THREADS;

    [CCode (cname = "ZMQ_MAX_SOCKETS")]
    public const int MAX_SOCKETS;

    /* Default for new contexts */
    [CCode (cname = "ZMQ_IO_THREADS_DFLT")]
    public const int IO_THREADS_DFLT;

    [CCode (cname = "ZMQ_MAX_SOCKETS_DFLT")]
    public const int MAX_SOCKETS_DFLT;

    [Compact]
    [CCode (cprefix = "zmq_ctx_", cname = "void", free_function = "zmq_ctx_destroy")]
    public class Context {
        [CCode (cname = "zmq_ctx_new")]
        public Context ();

        [CCode (cname = "zmq_ctx_set")]
        public int set_option (int option, int optval);

        [CCode (cname = "zmq_ctx_get")]
        public int get_option (int option);
    }

    /* Legacy context API - can't decide whether or not to remove completely. */

    namespace Legacy {
    [Compact]
        [CCode (cprefix = "zmq_", cname = "void", destroy_function = "zmq_ctx_destroy", free_function = "zmq_term")]
        public class Context {
            [CCode (cname = "zmq_init")]
            public Context (int io_threads);
        }
    }

    /* Message definition. */

    [CCode (cname = "zmq_free_fn", type = "void (*)(void *, void *)")]
    public delegate void free_fn (void *data);

    [CCode (cprefix = "zmq_msg_", cname = "zmq_msg_t", destroy_function = "zmq_msg_close", copy_function = "NO_IMPLICIT_COPY")]
    public struct Msg {

        [CCode (cname = "zmq_msg_init")]
        public Msg ();

        [CCode (cname = "zmq_msg_init_size")]
        public Msg.with_size (size_t size);

        [CCode (cname = "zmq_msg_init_data")]
        public Msg.with_data (owned uint8[] data, free_fn? ffn = GLib.free);

        [CCode (cname = "zmq_msg_send")]
        public int send (Socket socket, SendRecvOption flags = 0);

        [CCode (cname = "zmq_msg_recv")]
        public int recv (Socket socket, SendRecvOption flags = 0);

        [CCode (cname = "zmq_msg_close")]
        public int close ();

        [CCode (instance_pos = -1)]
        public int move (ref Msg dest);

        [CCode (cname = "zmq_msg_copy", instance_pos = -1)]
        private int _copy (ref Msg dest);

        [CCode (cname = "zmq_msg_copy_wrapper")]
        public Msg copy () {
            Msg msg = Msg ();
            this._copy (ref msg);
            return msg;
        }

        /* This isn't in v3.3.0, came from old vapi. */
        public Msg clone () {
            unowned uint8[] data = (uint8[]) GLib.Memory.dup((void*) this._data (), (uint) this.size ());
            data.length = (int) this.size ();
            Msg copy = Msg.with_data (data);
            return copy;
        }

        [CCode (cname = "zmq_msg_data")]
        private uint8 *_data ();
        public uint8[] data {
            get {
                unowned uint8[] data = (uint8[]) this._data ();
                data.length = (int) this.size ();
                return data;
            }
        }

        [CCode (cname = "zmq_msg_size")]
        public size_t size ();

        [CCode (cname = "zmq_msg_more")]
        public int more ();

        [CCode (cname = "zmq_msg_set")]
        public int set_option (int option, int optval);

        [CCode (cname = "zmq_msg_get")]
        public int get_option (int option);
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
        XSUB,
        STREAM
    }

    [CCode (cname = "int", cprefix = "ZMQ_")]
    public enum SocketOption {
        AFFINITY,
        IDENTITY,
        SUBSCRIBE,
        UNSUBSCRIBE,
        RATE,
        RECOVERY_IVL,
        SNDBUF,
        RCVBUF,
        RCVMORE,
        FD,
        EVENTS,
        TYPE,
        LINGER,
        RECONNECT_IVL,
        BACKLOG,
        RECONNECT_IVL_MAX,
        MAXMSGSIZE,
        SNDHWM,
        RCVHWM,
        MULTICAST_HOPS,
        RCVTIMEO,
        SNDTIMEO,
        LAST_ENDPOINT,
        ROUTER_MANDATORY,
        TCP_KEEPALIVE,
        TCP_KEEPALIVE_CNT,
        TCP_KEEPALIVE_IDLE,
        TCP_KEEPALIVE_INTVL,
        TCP_ACCEPT_FILTER,
        IMMEDIATE,
        XPUB_VERBOSE,
        ROUTER_RAW,
        IPV6,
        MECHANISM,
        PLAIN_SERVER,
        PLAIN_USERNAME,
        PLAIN_PASSWORD,
        CURVE_SERVER,
        CURVE_PUBLICKEY,
        CURVE_SECRETKEY,
        CURVE_SERVERKEY,
        PROBE_ROUTER,
        REQ_REQUEST_IDS,
        REQ_STRICT
    }

    [CCode (cname = "int", cprefix = "ZMQ_")]
    public enum SendRecvOption {
        DONTWAIT,
        SNDMORE
    }

    [CCode (cname = "int", cprefix = "ZMQ_")]
    public enum Security {
        NULL,
        PLAIN,
        CURVE
    }

    [CCode (cname = "int", cprefix = "ZMQ_EVENT_")]
    public enum SocketTransportEvent {
        CONNECTED,
        CONNECT_DELAYED,
        CONNECT_RETRIED,
        LISTENING,
        BIND_FAILED,
        ACCEPTED,
        ACCEPT_FAILED,
        CLOSED,
        CLOSE_FAILED,
        DISCONNECTED,
        MONITOR_STOPPED,
        ALL
    }

    [CCode (cprefix = "zmq_", cname = "zmq_event_t", copy_function = "NO_IMPLICIT_COPY")]
    public struct SocketEvent {
        /* XXX don't know if this is needed, not used as a param in any library function calls */
    }

    [Compact]
    [CCode (cprefix = "zmq_", cname = "void", free_function = "zmq_close")]
    public class Socket {
        [CCode (cname = "zmq_socket")]
        public static Socket? create (Context context, SocketType type);

        [CCode (simple_generics = true)]
        public int setsockopt <T> (SocketOption option, T optval, size_t optvallen);

        [CCode (simple_generics = true)]
        public int getsockopt <T> (SocketOption option, T optval, size_t optvallen);

        public int bind (string addr);

        public int connect (string addr);

        public int unbind (string addr);

        public int disconnect (string addr);

        public int send ([CCode (array_length = false)] uint8[] buf, size_t len, SendRecvOption flags = 0);

        public int recv ([CCode (array_length = false)] uint8[] buf, size_t len, SendRecvOption flags = 0);

        [CCode (cname = "zmq_socket_monitor")]
        public int monitor (string addr, SocketTransportEvent events = 0);

        public int sendmsg (ref Msg msg, SendRecvOption flags = 0);

        public int recvmsg (ref Msg msg, SendRecvOption flags = 0);
    }

    namespace Poll {
        [CCode (cname = "ZMQ_POLLIN")]
        public const short IN;

        [CCode (cname = "ZMQ_POLLOUT")]
        public const short OUT;

        [CCode (cname = "ZMQ_POLLERR")]
        public const short ERR;

        [CCode (cname = "zmq_pollitem_t")]
        public struct PollItem {
            Socket *socket;
            int fd;
            short events;
            short revents;
        }

        [CCode (cname = "zmq_poll")]
        public int poll (PollItem[] items, long timeout);
    }

    /* XXX wasn't sure how to include this */
    namespace Proxy {
        [CCode (cname = "zmq_proxy")]
        public int proxy (Socket frontend, Socket backend, Socket capture);
    }

    [Deprecated (since = "libzmq3")]
    [CCode (cname = "int", cprefix = "ZMQ_")]
    public enum Device {
        STREAMER,
        FORWARDER,
        QUEUE;
        [CCode (cname = "zmq_device")]
        public int device (Socket insocket, Socket outsocket);
    }
}
