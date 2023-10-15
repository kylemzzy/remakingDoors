local roomInfo = {
    ["StartRoom"] = {
        ["Weight"] = 0,
        ["Direction"] = "Straight",
        ["Stairs"] =  false
    },
    ["LeftBendRoom"] = {
        ["Weight"] = 4,
        ["Direction"] = "Left",
        ["Stairs"] =  false
    },
    ["RightBendRoom"] = {
        ["Weight"] = 4,
        ["Direction"] = "Right",
        ["Stairs"] =  false
    },
    ["SmallRoom"] = {
        ["Weight"] = 6,
        ["Direction"] = "Straight",
        ["Stairs"] =  false
    },
    ["LongRoom"] = {
        ["Weight"] = 3,
        ["Direction"] = "Straight",
        ["Stairs"] =  false
    },
    ["UpStairsRoom"] = {
        ["Weight"] = 1,
        ["Direction"] = "Straight",
        ["Stairs"] =  true
    },
    ["DownStairsRoom"] = {
        ["Weight"] = 1,
        ["Direction"] = "Straight",
        ["Stairs"] =  true
    },
    ["RareRoom"] = {
        ["Weight"] = 0.001,
        ["Direction"] = "Straight",
        ["Stairs"] =  false
    },

    
    
}


return roomInfo