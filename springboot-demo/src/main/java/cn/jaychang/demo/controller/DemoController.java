package cn.jaychang.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import javax.xml.crypto.Data;
import java.util.Locale;

/**
 * @author zhangjie
 * @package cn.jaychang.demo.controller
 * @description TODO
 * @create 2018-05-28 11:08
 */
@RestController
public class DemoController {
    @Autowired
    private MessageSource messageSource;

    @GetMapping("hello")
    public String hello(Locale locale){// 但这样每次都要写这个locale，不是很好
        String hello = messageSource.getMessage("hello",null,locale);
        return hello+" springboot docker";
    }

    @GetMapping("hello2")
    public String hello2(){
        String hello = messageSource.getMessage("hello",null,null);
        return hello+" springboot docker";
    }
}
