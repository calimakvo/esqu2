{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}


module Esq.Esquelechu (
    getUsers
) where

import Import
import qualified Prelude as P
import qualified Database.Esqueleto.Experimental as E

getUsers :: Param -> HandlerFor App ([(E.Entity UsrMember, E.Value Text, E.Value Int)], Int)
getUsers p = runDB $ do
    let pagePerLine = fromIntegral $ unPagePerLine p
        page = fromIntegral $ unPageNum p
        reqId = fromIntegral $ unReqId p
        typeIds = [1, 2]
        (ageFrom, ageTo) = (unAgeFrom p, unAgeTo p)
        baseQuery = do
          (usrMember E.:& usrImage E.:& usrAgeView) <-
            E.from $ E.table @UsrMember
            `E.InnerJoin` E.table @UsrImage
            `E.on` (\(usrMember E.:& usrImage) ->
                      usrMember E.^. UsrMemberUsrMemberId E.==. usrImage E.^. UsrImageUsrId)
            `E.InnerJoin` E.table @UsrAgeView
            `E.on` (\(usrMember E.:& _ E.:& usrAgeView) ->
                      usrMember E.^. UsrMemberUsrMemberId E.==. usrAgeView E.^. UsrAgeViewUid)
          E.where_ $ do
              let reqQuery = usrMember E.^. UsrMemberReqId E.==. E.val reqId
                  ageQuery = usrAgeView E.^. UsrAgeViewAge E.>=. E.val ageFrom
                                 E.&&. usrAgeView E.^. UsrAgeViewAge E.<=. E.val ageTo
              usrMember E.^. UsrMemberTypeId `E.in_` E.valList typeIds
                  E.&&. (if reqId > 0 then reqQuery else E.val True)
                  E.&&. (if ageFrom > 0 && ageTo > 0 then ageQuery else E.val True)
                  E.&&. usrImage E.^. UsrImageImageDiv E.==. E.val 2
          return (usrMember, usrImage E.^. UsrImageFileName, usrAgeView E.^. UsrAgeViewAge)
        baseQueryPage = do r <- baseQuery; E.offset (pagePerLine * page); E.limit pagePerLine; return r
    cnt <- P.length <$> E.select baseQuery
    s <- E.select baseQueryPage
    return (s,  cnt)
