//Basic config settings for developers
#define ENABLE_INSTALOAD TRUE

#define FALLBACK_TURF locate(VIEW_RANGE+1,VIEW_RANGE+1,1)

#define FPS_CLIENT 60 //0 Means synced. Also this is default, players can change this for themselves.
#define FPS_SERVER 30

#define WORLD_SIZE 500 //This shouldn't be touched unless you know what you're doing.
#define TILE_SIZE 32 //This shouldn't be touched unless you know what you're doing

#define MAX_MESSAGE_LEN 512
#define MAX_CHARACTERS 10 //Maximum amount of saved characters a player can have at once.
#define CHARGEN_DEFAULT_LEVEL 1 //Every skill, except luck, starts at this level.

#define MAX_INVENTORY_X 8

#define ROT_DELAY 3000 //300 seconds, 5 minutes

//Enables/disables biome music.
#define ENABLE_TRACKS FALSE

//Enables/disables floating damage numbers.
#define ENABLE_DAMAGE_NUMBERS TRUE

//Enables/disables bullet casings.
#define ENABLE_BULLET_CASINGS FALSE

//Enables/disables lighting.
#define ENABLE_LIGHTING FALSE

//Enables/disables turf/obj smoothing.
#define ENABLE_SMOOTHING FALSE

//Enable/disables combat testing by forcing a gamemode.
#define ENABLE_TDM FALSE

//Enables/disables turf generation
#define ENABLE_GENERATION TRUE

//Enables/disables atmos.
#define ENABLE_ATMOS FALSE

//Enables/disables weather.
#define ENABLE_WEATHERGEN FALSE

//Enables/disables combat messages outside combat log
#define ENABLE_HIT_MESSAGES FALSE

//Enables/disables wikibot helper functions
#define ENABLE_WIKIBOT FALSE

//Soft limit to prevent more than any of this amount of being on a single turf at once. THIS INCLUDES EVERYTHING THAT USES move(). forcemove() is intentionally ignored.
#define TURF_CONTENT_LIMIT 100