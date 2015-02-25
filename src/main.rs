extern crate saturdays_lobster;

use saturdays_lobster::server;

#[cfg(not(test))]
fn main() {
    server::start();
}
