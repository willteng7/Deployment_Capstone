package com.example.estore.controller;

import com.example.estore.model.Product;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

@RestController
public class AppController {

    @GetMapping("/products")
    public List<Product> getProducts() {
        return Arrays.asList(
            new Product(1L, "Laptop", "High-performance laptop", 1299.99, "Electronics"),
            new Product(2L, "Coffee Mug", "Keep your coffee hot", 15.99, "Office"),
            new Product(3L, "Keyboard", "Mechanical keyboard", 89.99, "Electronics")
        );
    }
}