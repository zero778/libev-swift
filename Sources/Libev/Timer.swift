import CLibev;

public class Timer {
	let loop: Loop;
	var timer: ev_timer;
	// var context: T?;

	var raw: UnsafeMutablePointer<ev_timer>? {
		get {
			return UnsafeMutablePointer<ev_timer>?(&timer);
		}
	}

	public var context: UnsafeMutableRawPointer? {
		get {
			return timer.data;
		}
		set {
			timer.data = newValue;
		}
	}

	convenience init(loop: Loop, after: Double, interval: Double, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_timer>?, Int32) -> Void)
	{
		self.init(context: nil, loop: loop, after: after, interval: interval, cb: cb)
	} 

	convenience init(loop: Loop, after: Double, interval: Double)
	{
		self.init(context: nil, loop: loop, after: after, interval: interval){
			(_:OpaquePointer?, p_timer:UnsafeMutablePointer<ev_timer>?, _:Int32) -> Void in
				print("timeout")
		}
	} 

	init(context: UnsafeMutableRawPointer?, loop: Loop, after: Double, interval: Double, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_timer>?, Int32) -> Void) 
	{
		self.loop  = loop;
		self.timer = ev_timer(context: context, after: after, interval: interval, cb: cb)
	}

	func start() 
	{
		ev_timer_start(loop.raw, self.raw)
	}

	func stop() 
	{
		ev_timer_stop(loop.raw, self.raw)
	}

	func again() 
	{
		ev_timer_again(loop.raw, self.raw)
	}
}

extension ev_timer {
	init(context: UnsafeMutableRawPointer?, after: Double, interval: Double, 
		cb: @escaping @convention(c)(OpaquePointer?, UnsafeMutablePointer<ev_timer>?, Int32) -> Void) 
	{
		self.cb       = cb;
		self.active   = 0;
		self.pending  = 0;
		self.priority = 0;
		self.at       = after;
		self.repeat   = interval;
		self.data     = context;
	}
}
