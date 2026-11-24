return {
    spritesheets = {
        [1] = {
            texture = "assets/environment/tiles_caves.png",
        }
    },
    tiles = {
        {
            id = 1,
            spritesheet = 1,
            name = "ground",
            description = "The ground",
            group = "terrain",
            frames = {
                default = { 1 },
            },
            passable = true,
            transparent = false,
        },
        {
            id = 2,
            spritesheet = 1,
            name = "wall",
            description = "Wall",
            group = "wall",
            frames = {
                default = { 2 },
            },
            passable = false,
            transparent = false,
        },
        {
            id = 3,
            spritesheet = 1,
            name = "ground2",
            description = "The ground2",
            group = "terrain",
            frames = {
                default = { 3 },
            },
            passable = true,
            transparent = false,
        },
        {
            id = 4,
            spritesheet = 1,
            name = "ground3",
            description = "The ground 3",
            group = "terrain",
            frames = {
                default = { 4 },
            },
            passable = true,
            transparent = false,
        },
        {
            id = 5,
            spritesheet = 1,
            name = "ground4",
            description = "The ground 4",
            group = "terrain",
            frames = {
                default = { 5 },
            },
            passable = true,
            transparent = false,
        },
        {
            id = 6,
            spritesheet = 1,
            name = "wall5",
            description = "The ground 5",
            group = "terrain",
            frames = {
                default = { 5 },
            },
            passable = true,
            transparent = false,
        }
    },
}