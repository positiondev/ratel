module RatelSpec (spec) where

import qualified Control.Exception as Exception
import qualified Ratel
import Test.Tasty.Hspec

spec :: Spec
spec = describe "Ratel" $ do
    describe "toError" $ do
        it "converts an Exception into an Error" $ do
            Exception.catch
                (do
                    _ <- error "something went wrong"
                    True `shouldBe` False)
                (\ exception -> do
                    let actual = Ratel.toError (exception :: Exception.SomeException)
                    let expected = Ratel.Error
                            { Ratel.errorBacktrace = Just
                                [ Ratel.Trace
                                    { Ratel.traceFile = Just "test-suite/RatelSpec.hs"
                                    , Ratel.traceMethod = Just "RatelSpec.toError"
                                    , Ratel.traceNumber = Just "16:34"
                                    }
                                ]
                            , Ratel.errorClass = Just "SomeException"
                            , Ratel.errorMessage = Just "\
                                \something went wrong\n\
                                \CallStack (from HasCallStack):\n\
                                \  error, called at test-suite/RatelSpec.hs:13:26 in main:RatelSpec"
                            , Ratel.errorSource = Nothing
                            , Ratel.errorTags = Nothing
                            }
                    actual `shouldBe` expected)
