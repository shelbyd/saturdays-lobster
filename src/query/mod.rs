extern crate core;
use self::core::str::FromStr;
use self::core::error::Error;
use self::core::fmt;

pub struct Query;

impl Query {
    pub fn execute(&self) -> String {
        String::from_str("PONG")
    }
}

impl FromStr for Query {
    type Err = ParseQueryErr;

    fn from_str(string: &str) -> Result<Query, ParseQueryErr> {
        let regex = regex!(r"^ping$");
        if regex.is_match(string) {
            Ok(Query)
        } else {
            Err(ParseQueryErr::new(QueryErrorKind::UnrecognizedCommand, string))
        }
    }
}

pub struct ParseQueryErr {
    kind: QueryErrorKind,
    details: String,
}

impl ParseQueryErr {
    fn new(kind: QueryErrorKind, details: &str) -> ParseQueryErr {
        ParseQueryErr { kind: kind,
                        details: String::from_str(details) }
    }
}

enum QueryErrorKind {
    UnrecognizedCommand
}

impl fmt::Display for ParseQueryErr {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self.kind {
            QueryErrorKind::UnrecognizedCommand =>
                format!("{} \"{}\"", self.description(), self.details).fmt(f)
        }
    }
}

impl Error for ParseQueryErr {
    fn description(&self) -> &str {
        match self.kind {
            QueryErrorKind::UnrecognizedCommand => "unrecognized command"
        }
    }
}
