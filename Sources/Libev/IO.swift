import CLibev;

public class IO {
	let loop: Loop;
	var io = ev_io();

	var raw: UnsafeMutablePointer<ev_io>? {
		get {
			return UnsafeMutablePointer<ev_io>?(&self.io)
		}
	}

	convenience init(loop: Loop, fd: Int32, events: Int, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_io>?, Int32) -> Void)
	{
		self.init(context: nil, loop: loop, fd: fd, events: events, cb: cb)
	} 

	init(context: UnsafeMutableRawPointer?, loop: Loop, fd: Int32, events: Int, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_io>?, Int32) -> Void) 
	{
		self.loop  = loop;
		self.io    = ev_io(context: context, fd: fd, events: events, cb: cb)
	}

	func start() {
		ev_io_start(loop.raw, self.raw)
	}

	func stop() {
		ev_io_stop(loop.raw, self.raw)
	}
}

extension ev_io {
	init(context: UnsafeMutableRawPointer?, fd: Int32, events: Int, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_io>?, Int32) -> Void) 
	{
		self.active   = 0;
		self.pending  = 0;
		self.priority = 0;
		self.cb       = cb;
		self.fd       = fd;
		self.data     = context;
		self.next     = nil;
		self.events   = Int32(events) | Int32(EV__IOFDSET);
	}
}