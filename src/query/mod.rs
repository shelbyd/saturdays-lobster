extern crate core;
use self::core::str::FromStr;

pub struct Query;

impl Query {
    pub fn execute(&self) -> String {
        String::from_str("PONG")
    }
}

impl FromStr for Query {
    type Err = ();

    fn from_str(string: &str) -> Result<Query, ()> {
        Ok(Query)
    }
}
