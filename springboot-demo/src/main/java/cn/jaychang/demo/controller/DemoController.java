package cn.jaychang.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author zhangjie
 * @package cn.jaychang.demo.controller
 * @description TODO
 * @create 2018-05-28 11:08
 */
@RestController
public class DemoController {
    @GetMapping("hello")
    public String hello(){
        return "hello springboot docker";
    }
}
