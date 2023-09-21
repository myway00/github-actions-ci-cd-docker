package com.study.cloud.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CloudController {
    @GetMapping("/")
    public String welcome() {
        return "contents changed ! ";
    }
}
