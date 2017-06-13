import CLibev;

struct LoopInitError: Error {
	let message: String
}

public final class Loop {
	var loop: OpaquePointer?;

	var raw: OpaquePointer? {
		get {
			return self.loop;
		}
	}

	init(flags: UInt32 = 0, global: Bool = true) throws {
		if global {
			guard let loop: OpaquePointer = ev_default_loop(flags) else 
			{
				throw LoopInitError(message: "could not initialise libev, bad $LIBEV_FLAGS in environment?")
			} 

			self.loop = loop;
		}
		else {
			guard let loop: OpaquePointer = ev_loop_new(flags) else 
			{
				throw LoopInitError(message: "could not initialise libev, bad $LIBEV_FLAGS in environment?")
			}

			self.loop = loop;
		}
	}

	deinit {
		ev_loop_destroy(loop!)
	}

	func run() {
		ev_run(loop, 0)
	}

	func stop(how: Int32) {
		ev_break(loop, how)
	}
}