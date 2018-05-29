package cn.jaychang.demo.service.impl;

import cn.jaychang.demo.service.DemoService;
import org.springframework.stereotype.Service;

/**
 * @author zhangjie
 * @package cn.jaychang.demo.service.impl
 * @description TODO
 * @create 2018-05-29 13:57
 */
@Service("demoService")
public class DemoServiceImpl implements DemoService {
    @Override
    public String hello(String name) {
        return "hello "+name;
    }
}
