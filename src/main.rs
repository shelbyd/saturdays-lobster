use std::old_io::{TcpListener, TcpStream};
use std::old_io::{Acceptor, Listener};
use std::thread;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:8888").unwrap();
    let mut acceptor = listener.listen().unwrap();
    for stream in acceptor.incoming() {
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

    drop(acceptor);
}

fn handle_client(mut stream: TcpStream) {
    let mut buf = [0; 4096];
    loop {
        match stream.read(&mut buf) {
            Err(err) => {
                println!("{}", err);
                break
            },
            Ok(amount_read) => {
                println!("read {} bytes", amount_read);
                let read = buf.slice(0, amount_read);
                println!("{}", std::str::from_utf8(read).ok().unwrap().trim());
                stream.write(read);
            }
        }
    };
}
