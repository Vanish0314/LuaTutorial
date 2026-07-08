-- 虽然协程类型是thread, 但是lua原生没有多线程模型

-- 协程的创建
function func()
    print("我是func, 我被执行了")
    print("[FUNC]当前函数所在线程号: ", coroutine.running())

    local i = 1
    while true do
        print("这是第"..i.."次执行")
        i = i + 1
        print(coroutine.status(co))
        coroutine.yield()
    end
    print("我是func, 这行不可能被执行")
end

co = coroutine.create(func)
print(co)
print("协程co的内容: " .. tostring(co) .. " 类型为:" .. type(co))

coWrap = coroutine.wrap(func) -- 返回的是一个函数
print(coWrap)
print("协程coWrap的内容: " .. tostring(coWrap) .. " 类型为:" .. type(coWrap))

coroutine.resume(co)
coWrap()
coWrap()
coWrap()
coWrap()

-- 协程的状态
-- suspended 暂停
-- running 运行中
-- dead 结束
print(coroutine.status(co))
print("[MAIN]当前函数所在线程号: ", coroutine.running())
