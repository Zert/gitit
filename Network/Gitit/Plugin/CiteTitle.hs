module Network.Gitit.Plugin.CiteTitle
  where

{- This plugin supports keeping notes in the style used by Caleb McDaniel
 - (http://wcm1.web.rice.edu/plain-text-citations.html). That is, you have
 - one wiki page per citable source and it contains a `bib` codeblock with
 - its bibtex entry. The plugin does two things:
 -
 - * If the current page doesn't have a title, but the URL matches
 -   one of its bibtex keys, the title for that bibtex entry will be used.
 -   If there's no title the key itself is used.

 - * If the current page includes a citation and there's a matching
 -   wiki page in the same directory, the citation will be replaced by a
 -   link to that page. The idea is that if you already wrote notes you
 -   probably want to go review them instead of jumping to the original
 -   source. Citations of the current source are ignored.
 -
 - TODO also add the pdf linking? Would be easy once you have the title...
 -      if that's in too, rename to "fancy" something
 -
 - Other bibtex is allowed too and will be ignored (or hopefully passed on
 - to my CiteProc plugin!)
 -
 - TODO rewrite documentation for just the first part
 -}

import Network.Gitit.Interface
import Network.Gitit.Plugin.CiteLinks (askName)
import Network.Gitit.Plugin.CiteProc  (separateBibliography, readBibliography)

import Data.Map           (union, fromList)
import Text.CSL.Reference (Reference, refId, titleShort, unLiteral)
import Text.CSL.Style     (unFormatted)

getBibliography :: Pandoc -> PluginM [Reference]
getBibliography doc = do
  let (_, bib) = separateBibliography doc
  bib' <- readBibliography bib
  return bib'

-- I couldn't figure out getReference Locators, so I worked around them
keyAndTitle :: Reference -> (String, [Inline])
keyAndTitle r = (unId r, unTitle r)
  where
    unId    = unLiteral   . refId
    unTitle = unFormatted . titleShort

setPageTitle :: Pandoc -> PluginM Pandoc
setPageTitle doc@(Pandoc m bs) = do
  refs <- getBibliography doc
  meta <- askMeta
  case lookup "title" meta of
    Just _  -> return doc
    Nothing -> do
      name <- askName
      case lookup name $ map keyAndTitle refs of
        Nothing -> return doc
        Just t  -> return $ Pandoc m' bs
          where
            old = unMeta m
            new = fromList [("title", MetaInlines t)]
            m'  = Meta {unMeta = union new old}

plugin :: Plugin
plugin = PageTransform setPageTitle
