--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
--------------------------------------------------------------------------------


main :: IO ()
main = do
    -- pubs <- readFile "publications.md"
    -- makeTemp "templates/publications-list.html" pubs
    hakyll $ do
        match "images/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "css/*" $ do
            route   idRoute
            compile compressCssCompiler

        match "publications/*.yaml" $ do
            compile getResourceString

        match "presentations/*.yaml" $ do
            compile getResourceString

        match "publications/*.pdf" $ do
            route idRoute
            compile copyFileCompiler

        match "presentations/*.pdf" $ do
            route idRoute
            compile copyFileCompiler

        match "posts/*" $ do
            route $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/post.html"    postCtx
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

        create ["blog.html"] $ do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let archiveCtx =
                        listField "posts" postCtx (return posts) `mappend`
                        constField "title" "Blog"                `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/blog.html" archiveCtx
                    >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                    >>= relativizeUrls

        create ["research.html"] $ do
            route idRoute
            compile $ do
                publications <- recentFirst =<< loadAll "publications/*.yaml"
                presentations <- recentFirst =<< loadAll "presentations/*.yaml"
                let researchCtx =
                        listField "publications" defaultContext (return publications) `mappend`
                        listField "presentations" defaultContext (return presentations) `mappend`
                        constField "title" "Research" `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/research.html" researchCtx
                    >>= loadAndApplyTemplate "templates/default.html" researchCtx
                    >>= relativizeUrls

        match "index.md" $ do
            route $ setExtension "html"
            compile $ do
                pandocCompiler
                    >>= applyAsTemplate defaultContext
                    >>= loadAndApplyTemplate "templates/default.html" defaultContext
                    >>= relativizeUrls

        match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

--How this would work with error handling, i think
--Basically, if the string doesn't contain |, we junk it
--need to think about how to deal with maybe values though
--
--This stuff all works fine, but I think I'm going to manually enter the stuff into html tables.
-- splitPipe' :: [String] -> [(String, String)]
-- splitPipe' s = map (break (=='|')) s
--
-- insRow :: [(String, String)] -> [String]
-- insRow [] = [""]
-- insRow ((x, y:ys):ps) = ("\t<tr><td class=\"year\">"++x++"</td><td class=\"pub\">"++ys++"</td></tr>"):rest
--        where rest = insRow ps
--
-- makeTable :: [String] -> String
-- makeTable rs = "<table>\n"++(concat (map (++"\n") rs))++"</table>"
--
-- makeTemp :: String -> String -> IO ()
-- makeTemp _ "" = return ()
-- makeTemp file x = writeFile file (makeTable . insRow . splitPipe' . lines $ x)
