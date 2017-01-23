import Network.MateLight.Simple
import Network.MateLight

import SDLEventProvider.SDLKeyEventProvider

import Control.Monad.State
import Control.Monad.Reader

import Data.Maybe
import qualified Network.Socket as Sock

type KeyStatus = (String, String, Integer) -- Represents the tuple (KeyStatusString, KeyNameString, Time) 


{-
	TODO: 
	- Geschwindigkeit Obstacles anpassen
	- Kollisionsabfrage generieren (wichtig!)
	- Obstacles field.txt erweitern
	- .:BONUS:. Geschwindigkeit erhöhen (bei längeren Spielverlauf)
-}

-- Color Codes for the Elements
backgroundPixel = Pixel 240 248 255
groundPixel = Pixel 160 82 45
saurPixel = Pixel 0 158 130
cactusPixel = Pixel 0 100 0
birdPixel = Pixel 220 20 60

-- Create Pixelsaur 
data Saur = Ducked | Normal | Jump Int deriving (Eq, Show)
data SaurState = SaurState {
  saur :: Saur
 ,field :: [[Obstacles]]
} deriving (Show, Eq)

-- Create Obstacles
data Obstacles = Free | Cactus | Bird | Ground deriving (Eq, Show)

-- Create Colors for the Obstacles
colours :: Obstacles -> Pixel
colours Ground = groundPixel
colours Cactus = cactusPixel
colours Bird = birdPixel
colours Free = backgroundPixel

-- Empty State for the Game
empty :: [[Obstacles]] -> SaurState
empty = SaurState Normal

-- Move the Pixelsaur (only UP and DOWN)
move :: (Int, Int) -> KeyStatus -> SaurState -> SaurState
move (xdim, ydim) ("Pressed","DOWN", _) saurState = saurState {saur = Ducked}
move (xdim, ydim) ("Released", "DOWN", _) saurState = saurState {saur = Normal}
move (xdim, ydim) ("Pressed", "UP", _) saurState = saurState {saur = Jump 0}
move (xdim, ydim) ("Released", "UP", _) saurState = saurState {saur = Normal}
move _ _ s = s

-- reate the Frame
myFrame :: (Int, Int) -> SaurState -> ListFrame
myFrame (xdim, ydim) saurState = ListFrame $ map (\y -> map (\x -> generate (saur saurState) x y) [0 .. xdim - 1]) [0 .. ydim - 1]
  where
  generate Normal x y | x == 1 && y >= 8 && y <= 10 = saurPixel
                      | otherwise =  colours $ (field saurState !! y) !! x
  generate Ducked x y | x == 1 && y >= 9 && y <= 10 || x == 2 && y == 9 = saurPixel
                      | otherwise =  colours $ (field saurState !! y) !! x
  generate (Jump d) x y = let d' = d `div` 3 in if isSaurJump d' (x, y) then saurPixel else colours $ (field saurState !! y) !! x
  isSaurJump d (x, y) | d <= 5 = x == 1 && y >= 8 - d && y <= 10 - d
                      | otherwise = x == 1 && y >= 8 - (10 - d) && y <= 10 - (10 - d)

getKeyDataTuples keyState = (map (\(k,t) -> ("Pressed",k,t)) (pressed $ keyState)) ++ (map (\(k,d) -> ("Held",k,d)) (held $ keyState)) ++ (map (\(k,t) -> ("Released",k,t)) (released $ keyState))

eventTest :: [EventT] -> MateMonad ListFrame SaurState IO ListFrame
eventTest events = do 
        state <- get
        let state' = case saur state of
                            Jump dur  | dur >= 30 -> state {saur = Normal}
                                      | otherwise -> state {saur = Jump (dur + 1)}
                            _ -> foldl (\acc (EventT mod ev) -> if mod == "SDL_KEY_DATA" then foldl (\accState key -> move dim key accState) acc (getKeyDataTuples (read $ show ev)) else acc) state events
        put $ state' {field = map tail $ field state'} --Geschwindigkeit ändern!
        return (myFrame dim state') 

dim :: (Int, Int)
dim = (30, 12)
  
main :: IO ()
main = do
    showSDLControlWindow
    -- Read field.txt
    field <- lines `fmap` readFile "field.txt"
    -- Create Obstacles from field.txt
    let field' = map (cycle . map (\c -> case c of {'_' -> Ground; '*' -> Cactus; 'x' -> Bird; _ -> Free})) field :: [[Obstacles]]
    Sock.withSocketsDo $ runMateM (Config (fromJust $ parseAddress "134.28.70.172") 1337 dim (Just 33000) True [sdlKeyEventProvider]) eventTest (empty field')
