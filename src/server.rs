use std::net::{TcpListener, TcpStream};
use std::old_io::{Acceptor, Listener};
use std::thread;
use std::io::{Read, Write};

extern crate std;

use query_executor::handle_query;

#[cfg(not(test))]
pub fn start() {
    let listener = TcpListener::bind("127.0.0.1:8888").unwrap();
    for stream in listener.incoming() {
        match stream {
            Err(err) => {
                println!("{}", err);
                break
            }
            Ok(stream) => {
                thread::spawn(move|| {
                    handle_client(stream)
                });
            }
        }
    }

    drop(listener);
}

fn handle_client(mut stream: TcpStream) {
    let mut buf = [0; 4096];
    loop {
        match stream.read(&mut buf) {
            Err(err) => {
                println!("{}", err);
                break
            },
            Ok(0) => {
                println!("connection closed");
                break
            },
            Ok(amount_read) => {
                let read = buf.slice(0, amount_read);
                let read_string = std::str::from_utf8(read).ok().unwrap().trim();
                log(&stream, format!("read: \"{}\"", read_string));
                let response = handle_query(read_string);
                log(&stream, format!("resp: \"{}\"", response));
                stream.write(format!("{}\n", response).as_bytes());
            }
        }
    };
}

fn log(stream: &TcpStream, message: String) {
    println!("remote={}: {}", stream.peer_addr().ok().unwrap(), message);
}
