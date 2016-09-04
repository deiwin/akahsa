import           Test.Tasty
import           Test.Tasty.Hspec
import qualified Data.Text as T (pack)
import qualified Akahsa.Commands as Com (stripOuchCommand, stripPainsCommand)

main :: IO ()
main = unitTests >>= defaultMain

unitTests :: IO TestTree
unitTests = testSpec "Unit tests" $ do
    describe "stripOuchCommand" $ do
        it "should strip lower case 'ouch'" $
            Com.stripOuchCommand (T.pack "ouch asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip capitalized 'ouch'" $
            Com.stripOuchCommand (T.pack "Ouch asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip slash prefixed 'ouch'" $
            Com.stripOuchCommand (T.pack "/ouch asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip slash prefixed capitalized 'ouch'" $
            Com.stripOuchCommand (T.pack "/Ouch asdf") `shouldBe` Just (T.pack "asdf")

    describe "stripPainsCommand" $ do
        it "should strip lower case 'pains'" $
            Com.stripPainsCommand (T.pack "pains asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip capitalized 'pains'" $
            Com.stripPainsCommand (T.pack "Pains asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip slash prefixed 'pains'" $
            Com.stripPainsCommand (T.pack "/pains asdf") `shouldBe` Just (T.pack "asdf")

        it "should strip slash prefixed capitalized 'pains'" $
            Com.stripPainsCommand (T.pack "/Pains asdf") `shouldBe` Just (T.pack "asdf")

