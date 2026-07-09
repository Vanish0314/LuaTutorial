--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-08 21:35:12
LastEditTime: 2026-07-08 21:35:19
--------------------------------------------------------------------------------
--]]
-- Markov Chain Text Generator

local ORDER = 5          -- 前缀长度：使用前几个词预测下一个词
local MAXGEN = 114514    -- 最多生成多少个词
local NOWORD = "\n"      -- 起始/结束标记

local sampleText = [[
How Markov Chains Create Random but Meaningful Text
A Markov chain is a simple but powerful model for generating sequences. It can be used to describe weather changes, board game movements, music patterns, and even written language. When applied to text generation, a Markov chain produces words by looking at what words usually follow other words in a given source text.
The basic idea is surprisingly easy to understand. First, the program reads a sample text and records patterns. For example, if the phrase “the more” is often followed by the word “we,” then the program remembers that relationship. Later, when it needs to generate new text and it sees “the more,” it may choose “we” as the next word. If several words have appeared after the same phrase, the program chooses randomly among them.
This is why Markov chain text feels both random and familiar. It is random because the next word is selected by chance. However, it is not completely random, because the choices come from real patterns found in the original text. A Markov chain does not truly understand grammar, meaning, or intention, but it can imitate the surface style of a text quite well.
The number of previous words used as context is important. If the program only looks at one previous word, the result may be very unpredictable and sometimes strange. If it looks at two or three previous words, the generated text usually becomes more natural. However, if the context becomes too long, the program may simply copy large parts of the original text instead of creating something new.
For example, with a two-word prefix, the program might learn that “we learn” can be followed by “more,” and “learn more” can be followed by “about.” By moving this two-word window forward one word at a time, the generator creates a chain of connected words. Each step depends only on the recent past, not on the entire history of the sentence.
This limitation is also what separates Markov chains from modern language models. A Markov chain has no deep understanding of ideas. It cannot plan an argument, maintain a complex theme, or reason about what it is saying. It simply follows statistical traces left by the original text. Modern language models, by contrast, use much larger contexts and more complex representations, allowing them to produce more coherent and meaningful writing.
Still, Markov chains remain useful and interesting. They are easy to implement, fun to experiment with, and excellent for teaching basic ideas about probability and text generation. They show that even simple statistical rules can create output that looks surprisingly human at first glance.
In the end, a Markov chain text generator is like a machine that dreams in borrowed phrases. It does not know what the words mean, but it remembers which words once stood beside each other. From those memories, it creates something new: random, patterned, and strangely familiar.
]]

local statetab = {}

local function prefixKey(prefix)
    return table.concat(prefix, " ")
end

local function insert(prefix, value)
    local key = prefixKey(prefix)
    local list = statetab[key]

    if list == nil then
        statetab[key] = { value }
    else
        list[#list + 1] = value
    end
end

local function shift(prefix, nextword)
    table.remove(prefix, 1)
    prefix[#prefix + 1] = nextword
end

local function allwords(text)
    local words = {}

    for word in string.gmatch(text, "%w+[,;.:]?") do
        words[#words + 1] = word
    end

    local i = 0
    return function()
        i = i + 1
        return words[i]
    end
end

local function newPrefix()
    local prefix = {}

    for i = 1, ORDER do
        prefix[i] = NOWORD
    end

    return prefix
end

-- 构建状态表
local prefix = newPrefix()

for word in allwords(sampleText) do
    insert(prefix, word)
    shift(prefix, word)
end

insert(prefix, NOWORD)

-- 生成文本
math.randomseed(os.time())

prefix = newPrefix()

for i = 1, MAXGEN do
    local list = statetab[prefixKey(prefix)]

    if list == nil then
        break
    end

    local nextword = list[math.random(#list)]

    if nextword == NOWORD then
        break
    end

    io.write(nextword, " ")
    shift(prefix, nextword)
end

io.write("\n")