--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc.Options
import           Control.Monad (liftM)
import           Data.Maybe (fromMaybe)
pandocReaderOptions :: ReaderOptions
pandocReaderOptions = defaultHakyllReaderOptions 
pandocWriterOptions :: WriterOptions
pandocWriterOptions = defaultHakyllWriterOptions
                      { writerHTMLMathMethod = MathJax ""  
                        , writerHtmlQTags = True }

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "Det statiska dammet"
    , feedDescription = "Dammig blogg"
    , feedAuthorName  = "Karl Pettersson"
    , feedAuthorEmail = "klpn1258@gmail.com"
    , feedRoot        = "https://static-dust.klpn.se"
    }

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match ("images/*" .||. "postdata/*" .||. "fonts/*" .||. "mathjax/**")  $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- build up tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    tagsRules tags $ \tag pattern -> do
        let title = "Poster taggade \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title
                      `mappend` listField "posts" postCtx (return posts)
                      `mappend` constField "lang" deflang 
                      `mappend` defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

        version "rss" $ do
            route   $ setExtension "xml"
            compile $ loadAllSnapshots pattern "content"
                >>= fmap (take 10) . recentFirst
                >>= renderRss myFeedConfiguration feedCtx

    match "posts/*.md" $ do
        route $ setExtension "html"
        compile $ do 
            id <- getUnderlying
            lang <- postlang id
            let posttemp = fromFilePath $ "templates/post"++lang++".html"
            bib <- bibtexCompiler $ lang
            loadAndApplyTemplate posttemp (postCtxWithTags tags) bib
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Arkiv"            `mappend`
                    constField "lang" deflang            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderAtom myFeedConfiguration feedCtx posts

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderRss myFeedConfiguration feedCtx posts

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Hem"                `mappend`
                    constField "lang" deflang            `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler
    match "*.bib" $ compile biblioCompiler
    match "*.csl" $ compile cslCompiler


--------------------------------------------------------------------------------
deflang :: [Char]
deflang = "sv" 

postlang :: MonadMetadata m => Identifier -> m [Char]
postlang id = liftM (fromMaybe deflang) $ getMetadataField id "lang"

postCtx :: Context String
postCtx =
    dateField "date" "%F" 
    `mappend` langCtx `mappend` defaultContext

feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

langCtx :: Context a 
langCtx = field "lang" $ \item -> do
   lang <- postlang (itemIdentifier item)  
   return $ lang

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags
    `mappend` postCtx

bibtexCompiler :: String -> Compiler (Item String)
bibtexCompiler lang = do 
    csl <- load (fromFilePath $ lang ++ ".csl")
    bib <- load "static-dust.bib"
    getResourceBody 
      >>= withItemBody (unixFilter "pandoc" [ "-F"
                                            , "pandoc-crossref"
                                            , "-t"
                                            , "markdown"
                                            , "-M"
                                            , "crossrefYaml=pandoc-crossref-"++lang++".yaml"
                                            ])
      >>= readPandocBiblio pandocReaderOptions csl bib
      >>= return . writePandocWith pandocWriterOptions
