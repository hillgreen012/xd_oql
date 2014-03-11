%{
#include <string.h>
#include <stdio.h>

#include <iostream>
#include <string>
#include <vector>
#include <set>
#include <sstream>
#include <cassert>
#include <cctype>

#include "YaccParam.hpp"

using namespace std;
extern int yylineno;

extern void clearBuffer(void);

string lowercaseString(const string& orig) {
    string result;
    size_t len = orig.size();
    for (size_t i = 0; i < len; i++) {
        char ch = orig[i];
        if (isalpha(ch) && isupper(ch)) {
            ch = tolower(ch);
        }
        result.push_back(ch);
    }
    return result;
}

char* lowercaseString(char* orig) {
    if (orig == 0 || orig[0] == 0) return orig;
    for (int i = 0; orig[i] != 0; ++i) {
        if (isalpha(orig[i]) && isupper(orig[i])) {
            orig[i] = tolower(orig[i]);
        }
    }
    return orig;
}

#ifdef __DEBUG__
#define TRACE do {                                      \
    cerr << "reduce at line " << __LINE__ << endl;      \
    yylineno = __LINE__;                                \
  } while(0)
#else
#   define TRACE
#endif

#define EXTCHARSIZE 90

extern "C"
{
  int yyerror(YaccParam* yp, char const *);
  extern int yylex(void);
}

%}

%parse-param {YaccParam* yp}

%union {
    std::string *str;
};

%token          EXISTS ON LIKE ESCAPE TERMINATOR COLON_EQUALS ST AS IN_P AND NOT BETWEEN
                WHERE GROUP ORDER BY HAVING DESC ASC TO IS NULL_P TRUE_P FALSE_P USING
                DISTINCT FROM FULL OUTER INNER JOIN LEFT RIGHT UNIQUE UNION ANY SOME ALL
                LIMIT_C  OFFSET_C LIMIT  OFFSET

%token <str>    EXTRACT NUMBER SFUNCNAME FUNCNAME AGGREGATE IDENT VALUE Op

%type <str>     alias_clause sub_type subquery_Op all_Op MathOp indirection
                type_function_name func_name opt_distinct opt_indirection
                indirection_el opt_asc_desc

/// Precedence: lowest to highest
%nonassoc       SET

/// see relation_expr_opt_alias
%left           UNION EXCEPT
%left           ST FROM WHERE ORDER BY
%left           INTERSECT
%left           OR
%left           AND
%right          NOT
%right          '='
%nonassoc       '<' '>'
%nonassoc       LIKE ILIKE SIMILAR
%nonassoc       ESCAPE
%nonassoc       OVERLAPS
%nonassoc       BETWEEN
%nonassoc       IN_P

/// dummy for postfix Op rules
%left           POSTFIXOP

/// ideally should have same precedence as IDENT
%nonassoc       UNBOUNDED
%nonassoc       IDENT NULL_P PARTITION RANGE ROWS PRECEDING FOLLOWING

/// multi-character ops and user-defined operators
%left           Op OPERATOR
%nonassoc       NOTNULL
%nonassoc       ISNULL

/// sets precedence for IS NULL, etc
%nonassoc       IS
%left           '+' '-'
%left           '*' '/' '%'
%left           '^'

 /// Unary Operators
%left           ','
%right          UMINUS
%left           '[' ']'
%left           '(' ')'
%left           '.'

%%

program
    : Selectstmt TERMINATOR 
    | Selectstmt
    ;

Selectstmt
    : select_no_parens  %prec UMINUS
    | select_with_parens %prec UMINUS
    ;

select_with_parens
    : '(' select_no_parens ')'
    | '(' select_with_parens ')'
    ;

select_no_parens
    : simple_select
    | select_no_parens UNION simple_select
    | select_no_parens UNION ALL simple_select
    ;

simple_select
    : ST opt_distinct target_list  from_clause  where_clause group_clause having_clause order_clause
    | from_clause ST opt_distinct target_list where_clause group_clause having_clause order_clause
    ;

opt_distinct
    : DISTINCT
    | DISTINCT ON '(' expr_list ')'
    | ALL
    |  /* EMPTY */
    ;

/*****************************************************************************
 *
 *      target list for SELECT
 *
 *****************************************************************************/
target_list
    : target_el
    | target_list ',' target_el
    ;

target_el
    : a_expr alias_clause
    | a_expr
    | '*'
    | exist_expr
    ;

a_expr
    : c_expr
    | LIMIT c_expr
    | LIMIT c_expr OFFSET c_expr
    | a_expr Op a_expr %prec Op
    | Op a_expr %prec Op
    | a_expr Op %prec POSTFIXOP
    | a_expr AND a_expr
    | a_expr OR a_expr
    | NOT a_expr
    | a_expr LIKE a_expr
    | a_expr LIKE a_expr ESCAPE VALUE
    | a_expr NOT LIKE a_expr
    | a_expr NOT LIKE a_expr ESCAPE VALUE
    | a_expr SIMILAR TO a_expr %prec SIMILAR
    | a_expr SIMILAR TO a_expr ESCAPE VALUE
    | a_expr NOT SIMILAR TO a_expr %prec SIMILAR
    | a_expr NOT SIMILAR TO a_expr ESCAPE VALUE
    | a_expr IS NULL_P %prec IS
    | a_expr ISNULL
    | a_expr IS NOT NULL_P %prec IS
    | a_expr NOTNULL
    | a_expr IS TRUE_P %prec IS
    | a_expr IS NOT TRUE_P %prec IS
    | a_expr IS FALSE_P %prec IS
    | a_expr IS NOT FALSE_P %prec IS
    | a_expr IS DISTINCT FROM a_expr %prec IS
    | a_expr IS NOT DISTINCT FROM a_expr %prec IS
    | a_expr BETWEEN b_expr AND b_expr %prec BETWEEN
    | a_expr NOT BETWEEN b_expr AND b_expr %prec BETWEEN
    | a_expr IN_P in_expr
    | a_expr NOT IN_P in_expr
    | a_expr subquery_Op sub_type select_with_parens %prec Op
    | a_expr subquery_Op sub_type '(' a_expr ')' %prec Op
    | UNIQUE select_with_parens
    | a_expr '+' a_expr
    | a_expr '-' a_expr
    | a_expr '*' a_expr
    | a_expr '/' a_expr
    | a_expr '%' a_expr
    | a_expr '^' a_expr
    | a_expr '<' a_expr
    | a_expr '>' a_expr
    | a_expr '=' a_expr
    ;

exist_expr
    : EXISTS select_no_parens
    | NOT EXISTS select_no_parens
    ;

b_expr
    : c_expr
    | '+' b_expr %prec UMINUS
    | '-' b_expr %prec UMINUS
    | b_expr '+' b_expr
    | b_expr '-' b_expr
    | b_expr '*' b_expr
    | b_expr '/' b_expr
    | b_expr '%' b_expr
    | b_expr '^' b_expr
    | b_expr '<' b_expr
    | b_expr '>' b_expr
    | b_expr '=' b_expr
    | b_expr Op b_expr %prec Op
    | Op b_expr %prec Op
    | b_expr Op %prec POSTFIXOP
    | b_expr IS DISTINCT FROM b_expr %prec IS
    | b_expr IS NOT DISTINCT FROM b_expr %prec IS
    ;

sub_type
    : ANY
    | SOME
    | ALL
    |  /* EMPTY */
    ;

subquery_Op
    : all_Op
    | LIKE
    | NOT LIKE
    ;

all_Op
    : Op
    | MathOp
    ;

MathOp
    : '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '^'
    | '<'
    | '>'
    | '='
    ;

in_expr
    : select_with_parens
    | '(' expr_list ')'
    ;

expr_list
    : a_expr
    | expr_list ',' a_expr
    ;

c_expr
    : columnref
    | '(' a_expr ')' opt_indirection
    | func_expr
    | VALUE
    | NUMBER
    | select_with_parens %prec UMINUS
    ;

columnref
    : IDENT
    | func_name
    | IDENT indirection
    | LIMIT_C
    | OFFSET_C
    ;

indirection
    : indirection_el
    | indirection indirection_el
    ;

func_expr
    : SFUNCNAME
    | func_name '(' ')'
    | func_name '(' func_arg_list ')'
    | func_name '(' '*' ')'
    | func_name '(' DISTINCT  '*' ')'
    | func_name '(' DISTINCT func_arg_list ')'
    ;

func_arg_list
    : func_arg_expr
    | func_arg_list ',' func_arg_expr
    ;

func_arg_expr
    : a_expr
    | IDENT COLON_EQUALS a_expr
    ;

/// Type/function identifier --- names that can be type or function names.
type_function_name
    : AGGREGATE
    | FUNCNAME
    ;

func_name
    : type_function_name
    ;

opt_indirection
    :  /* EMPTY */
    | opt_indirection indirection_el
    ;

indirection_el
    : '.' IDENT
    | '.' '*'
    ;

/*****************************************************************************
 *
 *      clauses common to all Optimizable Stmts:
 *              from_clause             - allow list of both JOIN expressions and table names
 *              where_clause    - qualifications for joins or restrictions
 *
 *****************************************************************************/
from_clause
    : FROM from_list
    |  /* EMPTY */
    ;

from_list
    : from_item
    | from_list ',' from_item 
    ;

from_item
    : table_ref
    | table_join
    | table_smt
    ;

table_ref  /* donot support db.table style */
    : IDENT
    {
        if (yp->tables != 0 && $1 != 0) {
            // yp->tables->insert(lowercaseString(*$1));
            yp->tables->insert(*$1);
        }
        delete $1;
    }
    | IDENT alias_clause
    {
        if (yp->tables != 0 && $1 != 0) {
            // yp->tables->insert(lowercaseString(*$1));
            yp->tables->insert(*$1);
        }
        delete $1;
        delete $2;
    }
    |'(' table_ref ')'
    ;

table_smt
    : select_with_parens
    | select_with_parens alias_clause
    ;

table_join
    : from_item LEFT JOIN from_item ON a_expr
    | from_item RIGHT JOIN from_item ON a_expr
    | from_item JOIN from_item ON a_expr
    | from_item LEFT OUTER JOIN from_item ON a_expr
    | from_item RIGHT OUTER JOIN from_item ON a_expr
    | from_item FULL JOIN from_item ON a_expr
    | from_item FULL OUTER JOIN from_item ON a_expr
    | from_item INNER JOIN from_item ON a_expr
    ;

alias_clause
    : AS IDENT
    {
        $$ = $2;
    }
    | AS FUNCNAME
    | AS AGGREGATE
    | IDENT
    {
        $$ = $1;
    }
    ;

/*****************************************************************************
 *
 *      clauses common to all Optimizable Stmts:
 *              where_clause    - qualifications for joins or restrictions
 *
 *****************************************************************************/

where_clause
    : WHERE a_expr
    |  /* EMPTY */
    ;

/*****************************************************************************
 *
 *              group by_clause 
 *
 *****************************************************************************/
group_clause
    : GROUP BY expr_list
    |  /* EMPTY */
    ;

/****************************************************************************_
 *
 *              having_clause    
 *
 *****************************************************************************/
having_clause
    : HAVING a_expr
    |  /* EMPTY */
    ;

/*****************************************************************************
 *
 *              order by_clause   
 *
 *****************************************************************************/
order_clause
    : sort_clause
    |  /* EMPTY */
    ;

sort_clause
    : ORDER BY sortby_list
    ;

sortby_list
    : sortby
    | sortby_list ',' sortby
    ;

sortby
    : a_expr opt_asc_desc
    ;

opt_asc_desc
    : ASC
    | DESC
    |  /* EMPTY */
    ;

%%

int yyerror(YaccParam* yp, char const *msg)
{
    if (msg == 0 || msg[0] == '\0') {
        printf("SQL_PANIC\n");
        return -1;
    }

    int len = strlen(msg);
    string msgstr;
    char ch;
    for (size_t i = 0; i < len; ++i) {
        ch = msg[i];
        if (ch == '\n' || ch == '\r') {
            ch = ' ';
        }
        msgstr.push_back(ch);
    }

    ostringstream sout;
    sout << "SQL_ERROR " << yylineno << " " << msgstr;

    // cerr << sout.str() << endl;

    if (yp->errmsgs != 0) {
        yp->errmsgs->push_back(sout.str());
    }

    return 0;
}
