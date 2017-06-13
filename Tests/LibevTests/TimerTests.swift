import XCTest;
import Foundation;
import CLibev;
@testable import Libev;

struct Context {
	var varbose: Int32 = 0;
}

class TimerTests: XCTestCase {
	static var tests = [
		("test", test),
	]


	func test() throws {
		let loop    = try!(Loop(flags: UInt32(EVBACKEND_POLL | EVBACKEND_SELECT | EVFLAG_NOENV)));
		var context = Context(varbose: 99);

		let io = IO(loop: loop, fd: 0, events: EV_READ) {
			(_:OpaquePointer?, p_io:UnsafeMutablePointer<ev_io>?, _:Int32) -> Void in
				print("data ready")
		}

		io.start();

		let timer = Timer(context: &context, loop: loop, after: 1.0, interval: 1.0){
			(loop :OpaquePointer?, p_timer:UnsafeMutablePointer<ev_timer>?, _:Int32) -> Void in
				guard let x: UnsafeMutableRawPointer = p_timer?.pointee.data else {
					return
				}

				let ctx: UnsafeMutablePointer<Context> = x.assumingMemoryBound(to: Context.self)

				ctx.pointee.varbose += 1;

				ev_break(loop, Int32(EVBREAK_ONE))
		};
		
		timer.start();

		loop.run();

		XCTAssertEqual(100, context.varbose);
	}
}