-- Autor: Alexandre Baizoukou

module DATA where


weight :: Int
weight = 1000

candidates :: Int
candidates = 4


---------------------------Looking at the Data ------------------

---  processing votes format from String to Integer

voteTrans :: String -> Int

---- a = "1"; a = "2"; a = "3" ; a = "4" ; a = "5" and else = 0

voteTrans a | a == "1" = 1 | 
