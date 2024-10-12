use std::collections::HashMap;
use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
struct Property {
    owner: String,
    status: String,
    price: u64,
    description: String,
}

#[derive(Debug)]
struct PropertyRegistry {
    properties: HashMap<u64, Property>,
    total_properties: u64,
}

impl PropertyRegistry {
    fn new() -> Self {
        PropertyRegistry {
            properties: HashMap::new(),
            total_properties: 0,
        }
    }

    fn register_property(&mut self, owner: String, description: String) -> u64 {
        let property_id = self.total_properties;
        let property = Property {
            owner,
            status: "registered".to_string(),
            price: 0,
            description,
        };
        self.properties.insert(property_id, property);
        self.total_properties += 1;
        property_id
    }

    fn list_property(&mut self, property_id: u64, price: u64) -> Result<(), &'static str> {
        if let Some(property) = self.properties.get_mut(&property_id) {
            if property.status == "registered" {
                property.status = "listed".to_string();
                property.price = price;
                Ok(())
            } else {
                Err("Property is already listed")
            }
        } else {
            Err("Property not found")
        }
    }

    fn get_property(&self, property_id: u64) -> Option<&Property> {
        self.properties.get(&property_id)
    }

    fn get_total_properties(&self) -> u64 {
        self.total_properties
    }
}

fn main() {
    println!("PropVerify Decentralized Property Registry");
    
    let mut registry = PropertyRegistry::new();
    
    // Example usage
    let property_id = registry.register_property(
        "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM".to_string(),
        "Beautiful 3-bedroom house in downtown".to_string()
    );
    println!("Registered property with ID: {}", property_id);
    
    match registry.list_property(property_id, 250000) {
        Ok(_) => println!("Property listed successfully"),
        Err(e) => println!("Error listing property: {}", e),
    }
    
    if let Some(property) = registry.get_property(property_id) {
        println!("Property details: {:?}", property);
    }
    
    println!("Total properties: {}", registry.get_total_properties());
}