-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParBNF where
import AbsBNF
import LexBNF
import ErrM

}

%name pLGrammar LGrammar
%name pLDef LDef
%name pListLDef ListLDef
%name pListIdent ListIdent
%name pGrammar Grammar
%name pListDef ListDef
%name pDef Def
%name pItem Item
%name pListItem ListItem
%name pCat Cat
%name pLabel Label
%name pLabelId LabelId
%name pProfItem ProfItem
%name pIntList IntList
%name pListInteger ListInteger
%name pListIntList ListIntList
%name pListProfItem ListProfItem
%name pArg Arg
%name pListArg ListArg
%name pSeparation Separation
%name pListString ListString
%name pExp Exp
%name pExp1 Exp1
%name pExp2 Exp2
%name pListExp ListExp
%name pListExp2 ListExp2
%name pRHS RHS
%name pListRHS ListRHS
%name pMinimumSize MinimumSize
%name pReg2 Reg2
%name pReg1 Reg1
%name pReg3 Reg3
%name pReg Reg
-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%token
  '(' { PT _ (TS _ 1) }
  ')' { PT _ (TS _ 2) }
  '*' { PT _ (TS _ 3) }
  '+' { PT _ (TS _ 4) }
  ',' { PT _ (TS _ 5) }
  '-' { PT _ (TS _ 6) }
  '.' { PT _ (TS _ 7) }
  ':' { PT _ (TS _ 8) }
  '::=' { PT _ (TS _ 9) }
  ';' { PT _ (TS _ 10) }
  '=' { PT _ (TS _ 11) }
  '?' { PT _ (TS _ 12) }
  '[' { PT _ (TS _ 13) }
  ']' { PT _ (TS _ 14) }
  '_' { PT _ (TS _ 15) }
  'char' { PT _ (TS _ 16) }
  'coercions' { PT _ (TS _ 17) }
  'comment' { PT _ (TS _ 18) }
  'define' { PT _ (TS _ 19) }
  'delimiters' { PT _ (TS _ 20) }
  'digit' { PT _ (TS _ 21) }
  'entrypoints' { PT _ (TS _ 22) }
  'eps' { PT _ (TS _ 23) }
  'internal' { PT _ (TS _ 24) }
  'layout' { PT _ (TS _ 25) }
  'letter' { PT _ (TS _ 26) }
  'lower' { PT _ (TS _ 27) }
  'nonempty' { PT _ (TS _ 28) }
  'position' { PT _ (TS _ 29) }
  'rules' { PT _ (TS _ 30) }
  'separator' { PT _ (TS _ 31) }
  'stop' { PT _ (TS _ 32) }
  'terminator' { PT _ (TS _ 33) }
  'token' { PT _ (TS _ 34) }
  'toplevel' { PT _ (TS _ 35) }
  'upper' { PT _ (TS _ 36) }
  'views' { PT _ (TS _ 37) }
  '{' { PT _ (TS _ 38) }
  '|' { PT _ (TS _ 39) }
  '}' { PT _ (TS _ 40) }

L_ident  { PT _ (TV $$) }
L_quoted { PT _ (TL $$) }
L_integ  { PT _ (TI $$) }
L_charac { PT _ (TC $$) }
L_doubl  { PT _ (TD $$) }


%%

Ident   :: { Ident }   : L_ident  { Ident $1 }
String  :: { String }  : L_quoted {  $1 }
Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }
Char    :: { Char }    : L_charac { (read ( $1)) :: Char }
Double  :: { Double }  : L_doubl  { (read ( $1)) :: Double }

LGrammar :: { LGrammar }
LGrammar : ListLDef { AbsBNF.LGr $1 }
LDef :: { LDef }
LDef : Def { AbsBNF.DefAll $1 }
     | ListIdent ':' Def { AbsBNF.DefSome $1 $3 }
     | 'views' ListIdent { AbsBNF.LDefView $2 }
ListLDef :: { [LDef] }
ListLDef : {- empty -} { [] }
         | LDef { (:[]) $1 }
         | LDef ';' ListLDef { (:) $1 $3 }
ListIdent :: { [Ident] }
ListIdent : Ident { (:[]) $1 } | Ident ',' ListIdent { (:) $1 $3 }
Grammar :: { Grammar }
Grammar : ListDef { AbsBNF.Grammar $1 }
ListDef :: { [Def] }
ListDef : {- empty -} { [] }
        | Def { (:[]) $1 }
        | Def ';' ListDef { (:) $1 $3 }
Def :: { Def }
Def : Label '.' Cat '::=' ListItem { AbsBNF.Rule $1 $3 (reverse $5) }
    | 'comment' String { AbsBNF.Comment $2 }
    | 'comment' String String { AbsBNF.Comments $2 $3 }
    | 'internal' Label '.' Cat '::=' ListItem { AbsBNF.Internal $2 $4 (reverse $6) }
    | 'token' Ident Reg { AbsBNF.Token $2 $3 }
    | 'position' 'token' Ident Reg { AbsBNF.PosToken $3 $4 }
    | 'entrypoints' ListIdent { AbsBNF.Entryp $2 }
    | 'separator' MinimumSize Cat String { AbsBNF.Separator $2 $3 $4 }
    | 'terminator' MinimumSize Cat String { AbsBNF.Terminator $2 $3 $4 }
    | 'delimiters' Cat String String Separation MinimumSize { AbsBNF.Delimiters $2 $3 $4 $5 $6 }
    | 'coercions' Ident Integer { AbsBNF.Coercions $2 $3 }
    | 'rules' Ident '::=' ListRHS { AbsBNF.Rules $2 $4 }
    | 'define' Ident ListArg '=' Exp { AbsBNF.Function $2 (reverse $3) $5 }
    | 'layout' ListString { AbsBNF.Layout $2 }
    | 'layout' 'stop' ListString { AbsBNF.LayoutStop $3 }
    | 'layout' 'toplevel' { AbsBNF.LayoutTop }
Item :: { Item }
Item : String { AbsBNF.Terminal $1 } | Cat { AbsBNF.NTerminal $1 }
ListItem :: { [Item] }
ListItem : {- empty -} { [] } | ListItem Item { flip (:) $1 $2 }
Cat :: { Cat }
Cat : '[' Cat ']' { AbsBNF.ListCat $2 } | Ident { AbsBNF.IdCat $1 }
Label :: { Label }
Label : LabelId { AbsBNF.LabNoP $1 }
      | LabelId ListProfItem { AbsBNF.LabP $1 $2 }
      | LabelId LabelId ListProfItem { AbsBNF.LabPF $1 $2 $3 }
      | LabelId LabelId { AbsBNF.LabF $1 $2 }
LabelId :: { LabelId }
LabelId : Ident { AbsBNF.Id $1 }
        | '_' { AbsBNF.Wild }
        | '[' ']' { AbsBNF.ListE }
        | '(' ':' ')' { AbsBNF.ListCons }
        | '(' ':' '[' ']' ')' { AbsBNF.ListOne }
ProfItem :: { ProfItem }
ProfItem : '(' '[' ListIntList ']' ',' '[' ListInteger ']' ')' { AbsBNF.ProfIt $3 $7 }
IntList :: { IntList }
IntList : '[' ListInteger ']' { AbsBNF.Ints $2 }
ListInteger :: { [Integer] }
ListInteger : {- empty -} { [] }
            | Integer { (:[]) $1 }
            | Integer ',' ListInteger { (:) $1 $3 }
ListIntList :: { [IntList] }
ListIntList : {- empty -} { [] }
            | IntList { (:[]) $1 }
            | IntList ',' ListIntList { (:) $1 $3 }
ListProfItem :: { [ProfItem] }
ListProfItem : ProfItem { (:[]) $1 }
             | ProfItem ListProfItem { (:) $1 $2 }
Arg :: { Arg }
Arg : Ident { AbsBNF.Arg $1 }
ListArg :: { [Arg] }
ListArg : {- empty -} { [] } | ListArg Arg { flip (:) $1 $2 }
Separation :: { Separation }
Separation : {- empty -} { AbsBNF.SepNone }
           | 'terminator' String { AbsBNF.SepTerm $2 }
           | 'separator' String { AbsBNF.SepSepar $2 }
ListString :: { [String] }
ListString : String { (:[]) $1 }
           | String ',' ListString { (:) $1 $3 }
Exp :: { Exp }
Exp : Exp1 ':' Exp { AbsBNF.Cons $1 $3 } | Exp1 { $1 }
Exp1 :: { Exp }
Exp1 : Ident ListExp2 { AbsBNF.App $1 $2 } | Exp2 { $1 }
Exp2 :: { Exp }
Exp2 : Ident { AbsBNF.Var $1 }
     | Integer { AbsBNF.LitInt $1 }
     | Char { AbsBNF.LitChar $1 }
     | String { AbsBNF.LitString $1 }
     | Double { AbsBNF.LitDouble $1 }
     | '[' ListExp ']' { AbsBNF.List $2 }
     | '(' Exp ')' { $2 }
ListExp :: { [Exp] }
ListExp : {- empty -} { [] }
        | Exp { (:[]) $1 }
        | Exp ',' ListExp { (:) $1 $3 }
ListExp2 :: { [Exp] }
ListExp2 : Exp2 { (:[]) $1 } | Exp2 ListExp2 { (:) $1 $2 }
RHS :: { RHS }
RHS : ListItem { AbsBNF.RHS (reverse $1) }
ListRHS :: { [RHS] }
ListRHS : RHS { (:[]) $1 } | RHS '|' ListRHS { (:) $1 $3 }
MinimumSize :: { MinimumSize }
MinimumSize : 'nonempty' { AbsBNF.MNonempty }
            | {- empty -} { AbsBNF.MEmpty }
Reg2 :: { Reg }
Reg2 : Reg2 Reg3 { AbsBNF.RSeq $1 $2 } | Reg3 { $1 }
Reg1 :: { Reg }
Reg1 : Reg1 '|' Reg2 { AbsBNF.RAlt $1 $3 }
     | Reg2 '-' Reg2 { AbsBNF.RMinus $1 $3 }
     | Reg2 { $1 }
Reg3 :: { Reg }
Reg3 : Reg3 '*' { AbsBNF.RStar $1 }
     | Reg3 '+' { AbsBNF.RPlus $1 }
     | Reg3 '?' { AbsBNF.ROpt $1 }
     | 'eps' { AbsBNF.REps }
     | Char { AbsBNF.RChar $1 }
     | '[' String ']' { AbsBNF.RAlts $2 }
     | '{' String '}' { AbsBNF.RSeqs $2 }
     | 'digit' { AbsBNF.RDigit }
     | 'letter' { AbsBNF.RLetter }
     | 'upper' { AbsBNF.RUpper }
     | 'lower' { AbsBNF.RLower }
     | 'char' { AbsBNF.RAny }
     | '(' Reg ')' { $2 }
Reg :: { Reg }
Reg : Reg1 { $1 }
{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    t:_ -> " before `" ++ id(prToken t) ++ "'"

myLexer = tokens
}

