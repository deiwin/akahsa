import           Test.Tasty
import           Test.Tasty.Hspec
import qualified Data.Text as T (pack)
import qualified Akahsa.Commands as Com (stripOuchCommand)

main :: IO ()
main = unitTests >>= defaultMain

unitTests :: IO TestTree
unitTests = testSpec "Unit tests" $
    describe "stripOuchCommand" $
        it "should strip lower case 'ouch'" $
            Com.stripOuchCommand (T.pack "ouch asdf") `shouldBe` Just (T.pack "asdf")

