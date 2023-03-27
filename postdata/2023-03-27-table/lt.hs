{-# LANGUAGE DeriveGeneric #-}
import Data.Char
import Data.Csv
import Data.List
import GHC.Generics (Generic)
import System.IO (hPutStrLn, stderr)
import qualified Data.ByteString.Lazy.Char8 as BL8
import qualified Data.Vector as V

type Age = Int
type DeathCount = Int
type Rate = Double
type Probability = Double
type LifeTime = Double

data DeathsMpop = DeathsMpop { age :: !Age
                             , deaths :: !DeathCount
                             , mpop :: !LifeTime
                             } deriving (Generic, Show)

instance FromNamedRecord DeathsMpop
instance ToNamedRecord DeathsMpop
instance DefaultOrdered DeathsMpop

data LifeTableRow = LifeTableRow { x :: !Age
                                 , mx :: !Rate
                                 , qx :: !Probability
                                 , lx :: !Probability
                                 , dx :: !Probability
                                 , ex :: !LifeTime 
                                 } deriving (Generic, Show)

instance FromNamedRecord LifeTableRow
instance ToNamedRecord LifeTableRow
instance DefaultOrdered LifeTableRow

periodLifeTable :: [DeathsMpop] -> [LifeTableRow]
periodLifeTable dthspop = zipWith6 LifeTableRow x' mx' qx' lx' dx' ex'
    where x' = age <$> dthspop 
          dt = deaths <$> dthspop
          mp = mpop <$> dthspop
          mx' = zipWith (\d p -> (fromIntegral d) / p) dt mp
          qx' = (init $ (\m -> m / (1 + 0.5 * m)) <$> mx') ++ [1.0]
          px' = (\q -> 1 - q) <$> qx'
          lx' = tail $ product <$> inits (1.0:init px')
          dx' = zipWith (*) qx' lx'
          ldend = (last lx') * 1/(last mx')
          ldx' = (init $ zipWith (\l d -> l - 0.5 * d) lx' dx') ++ [ldend]
          tx' = init $ sum <$> tails ldx'
          ex' = zipWith (/) tx' lx'

main :: IO ()
main = do
    let tsvDecOs = defaultDecodeOptions {decDelimiter = fromIntegral (ord '\t')} 
    let tsvEncOs = defaultEncodeOptions {encDelimiter = fromIntegral (ord '\t')} 
    csvData <- BL8.getContents
    case decodeByNameWith tsvDecOs csvData :: Either String (Header, V.Vector DeathsMpop) of
         Left err -> hPutStrLn stderr err
         Right (_, v) -> do
              let lt = periodLifeTable $ V.toList v
              BL8.putStr $ encodeDefaultOrderedByNameWith tsvEncOs lt
