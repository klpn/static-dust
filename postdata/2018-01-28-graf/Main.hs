{-# LANGUAGE DeriveGeneric #-}

module Main where

import           Data.Csv
import           Data.Either
import           Data.Function
import           Data.List
import           GHC.Generics
import           Graphics.Matplotlib
import           System.Process.ByteString.Lazy
import qualified Data.ByteString.Lazy as L8
import qualified Data.Map.Strict as M
import qualified Data.Vector as V

data Increcord = Increcord { year :: !Int
                           , sex :: !String
                           , age :: !Int
                           , inc :: !Double } deriving (Generic, Show)

instance FromNamedRecord Increcord

increc_csv (_, csvdata, _) =
    decodeByName csvdata :: Either String (Header, V.Vector Increcord)

mean :: (Fractional a, Foldable t) => t a -> a
mean xs = (sum xs) / fromIntegral (length xs)

sexLogIncs :: String ->  M.Map String [[Increcord]] -> ([Int], [Double])
sexLogIncs sex ssir = (ages, logincs) where
    sir = M.findWithDefault [] sex ssir
    ages = map age (map head sir)
    logincs = map (log . (/10**5) . mean) (map inc <$> sir)

sexesagesIncRecs :: IO (M.Map String [[Increcord]])
sexesagesIncRecs = do
    sraw <- L8.readFile "Statistikdatabasen_2018-01-27 00_13_00.csv"
    rcsv <- readProcessWithExitCode "awk" ["-f", "sos.awk"] sraw
    let incrcs = V.toList (snd (fromRight (V.empty, V.empty) (increc_csv rcsv)))
    let incrcs_s = groupBy ((==) `on` sex) (sortOn sex incrcs)
    let incrcs_sa = groupBy ((==) `on` age) <$> (map (sortOn age) incrcs_s)
    let sexes = map sex (map head incrcs_s)
    let s_incrcs = zip sexes incrcs_sa
    return (M.fromList s_incrcs)

femaPlot :: IO ()
femaPlot = do
    sxsasir <- sexesagesIncRecs
    let ufli = sexLogIncs "F" sxsasir
    let umli = sexLogIncs "M" sxsasir
    let fmpl = plot (fst ufli) (snd ufli) @@ [o1 "o-", o2 "label" "Kvinnor"]
         % plot (fst umli) (snd umli) @@ [o1 "o-", o2 "label" "Män"]
         % title "Sjukhusvårdade luftvägsinfektioner Sverige 2009–16"
         % legend
         % xlabel "Ålder"
         % ylabel "log(incidens, vårdtillfällen)"
         % grid True
    onscreen fmpl

main :: IO ()
main = femaPlot
