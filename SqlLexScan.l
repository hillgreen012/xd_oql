%{
#include <iostream>
#include <vector>
#include <string>
#include "SqlSyntax.hpp"
    
void cleanBuffer(void);

using namespace std;

#ifdef __DEBUG__
#define DEBUGLEX(arg1, arg2) do{\
        std::cout << arg1 << "\t:" << arg2 << endl;\
    }while(0)
#else
#define DEBUGLEX(arg1, arg2)
#endif

#define NAMEDATALEN 60

extern YYSTYPE yylval;

extern "C"
{
    int yywrap(void);
    int yylex(void);
}
%}

%option yylineno

decode ([dD][eE][cC][oO][dD][eE])
abs    ([aA][bB][sS])
acos    ([aA][cC][oO][sS])
add_months    ([aA][dD][dD]_[mM][oO][nN][tT][hH][sS])
asciistr    ([aA][sS][cC][iI][iI][sS][tT][rR])
asin    ([aA][sS][iI][nN])
atan    ([aA][tT][aA][nN])
atan2    ([aA][tT][aA][nN][22])
bin_to_num    ([bB][iI][nN]_[tT][oO]_[nN][uU][mM])
bitand    ([bB][iI][tT][aA][nN][dD])
cardinality    ([cC][aA][rR][dD][iI][nN][aA][lL][iI][tT][yY])
cast    ([cC][aA][sS][tT])
ceil    ([cC][eE][iI][lL])
chartorowid    ([cC][hH][aA][rR][tT][oO][rR][oO][wW][iI][dD])
chr    ([cC][hH][rR])
cluster_id    ([cC][lL][uU][sS][tT][eE][rR]_[iI][dD])
cluster_probability    ([cC][lL][uU][sS][tT][eE][rR]_[pP][rR][oO][bB][aA][bB][iI][lL][iI][tT][yY])
cluster_set    ([cC][lL][uU][sS][tT][eE][rR]_[sS][eE][tT])
collect    ([cC][oO][lL][lL][eE][cC][tT])
compose    ([cC][oO][mM][pP][oO][sS][eE])
concat    ([cC][oO][nN][cC][aA][tT])
convert    ([cC][oO][nN][vV][eE][rR][tT])
cos    ([cC][oO][sS])
cosh    ([cC][oO][sS][hH])
current_date    ([cC][uU][rR][rR][eE][nN][tT]_[dD][aA][tT][eE])
current_timestamp    ([cC][uU][rR][rR][eE][nN][tT]_[tT][iI][mM][eE][sS][tT][aA][mM][pP])
dbtimezone    ([dD][bB][tT][iI][mM][eE][zZ][oO][nN][eE])
decompose    ([dD][eE][cC][oO][mM][pP][oO][sS][eE])
exp    ([eE][xX][pP])
extract    ([eE][xX][tT][rR][aA][cC][tT])
feature_id    ([fF][eE][aA][tT][uU][rR][eE]_[iI][dD])
feature_set    ([fF][eE][aA][tT][uU][rR][eE]_[sS][eE][tT])
feature_value    ([fF][eE][aA][tT][uU][rR][eE]_[vV][aA][lL][uU][eE])
floor    ([fF][lL][oO][oO][rR])
from_tz    ([fF][rR][oO][mM]_[tT][zZ])
greatest    ([gG][rR][eE][aA][tT][eE][sS][tT])
hextoraw    ([hH][eE][xX][tT][oO][rR][aA][wW])
initcap    ([iI][nN][iI][tT][cC][aA][pP])
last_day    ([lL][aA][sS][tT]_[dD][aA][yY])
least    ([lL][eE][aA][sS][tT])
ln    ([lL][nN])
localtimestamp    ([lL][oO][cC][aA][lL][tT][iI][mM][eE][sS][tT][aA][mM][pP])
log    ([lL][oO][gG])
lower    ([lL][oO][wW][eE][rR])
lpad    ([lL][pP][aA][dD])
ltrim    ([lL][tT][rR][iI][mM])
mod    ([mM][oO][dD])
months_between    ([mM][oO][nN][tT][hH][sS]_[bB][eE][tT][wW][eE][eE][nN])
nanvl    ([nN][aA][nN][vV][lL])
new_time    ([nN][eE][wW]_[tT][iI][mM][eE])
next_day    ([nN][eE][xX][tT]_[dD][aA][yY])
nls_charset_decl_len    ([nN][lL][sS]_[cC][hH][aA][rR][sS][eE][tT]_[dD][eE][cC][lL]_[lL][eE][nN])
nls_charset_id    ([nN][lL][sS]_[cC][hH][aA][rR][sS][eE][tT]_[iI][dD])
nls_charset_name    ([nN][lL][sS]_[cC][hH][aA][rR][sS][eE][tT]_[nN][aA][mM][eE])
nls_initcap    ([nN][lL][sS]_[iI][nN][iI][tT][cC][aA][pP])
nls_lower    ([nN][lL][sS]_[lL][oO][wW][eE][rR])
nlssort    ([nN][lL][sS][sS][oO][rR][tT])
nls_upper    ([nN][lL][sS]_[uU][pP][pP][eE][rR])
numtodsinterval    ([nN][uU][mM][tT][oO][dD][sS][iI][nN][tT][eE][rR][vV][aA][lL])
numtoyminterval    ([nN][uU][mM][tT][oO][yY][mM][iI][nN][tT][eE][rR][vV][aA][lL])
power    ([pP][oO][wW][eE][rR])
powermultiset    ([pP][oO][wW][eE][rR][mM][uU][lL][tT][iI][sS][eE][tT])
powermultiset_by_cardinality    ([pP][oO][wW][eE][rR][mM][uU][lL][tT][iI][sS][eE][tT]_[bB][yY]_[cC][aA][rR][dD][iI][nN][aA][lL][iI][tT][yY])
prediction    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN])
prediction_bounds    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN]_[bB][oO][uU][nN][dD][sS])
prediction_cost    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN]_[cC][oO][sS][tT])
prediction_details    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN]_[dD][eE][tT][aA][iI][lL][sS])
prediction_probability    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN]_[pP][rR][oO][bB][aA][bB][iI][lL][iI][tT][yY])
prediction_set    ([pP][rR][eE][dD][iI][cC][tT][iI][oO][nN]_[sS][eE][tT])
rawtohex    ([rR][aA][wW][tT][oO][hH][eE][xX])
rawtonhex    ([rR][aA][wW][tT][oO][nN][hH][eE][xX])
regexp_replace    ([rR][eE][gG][eE][xX][pP]_[rR][eE][pP][lL][aA][cC][eE])
regexp_substr    ([rR][eE][gG][eE][xX][pP]_[sS][uU][bB][sS][tT][rR])
remainder    ([rR][eE][mM][aA][iI][nN][dD][eE][rR])
replace    ([rR][eE][pP][lL][aA][cC][eE])
round    ([rR][oO][uU][nN][dD])
rowidtochar    ([rR][oO][wW][iI][dD][tT][oO][cC][hH][aA][rR])
rowidtonchar    ([rR][oO][wW][iI][dD][tT][oO][nN][cC][hH][aA][rR])
rpad    ([rR][pP][aA][dD])
rtrim    ([rR][tT][rR][iI][mM])
scn_to_timestamp    ([sS][cC][nN]_[tT][oO]_[tT][iI][mM][eE][sS][tT][aA][mM][pP])
sessiontimezone    ([sS][eE][sS][sS][iI][oO][nN][tT][iI][mM][eE][zZ][oO][nN][eE])
set    ([sS][eE][tT])
sign    ([sS][iI][gG][nN])
sin    ([sS][iI][nN])
sinh    ([sS][iI][nN][hH])
soundex    ([sS][oO][uU][nN][dD][eE][xX])
sqrt    ([sS][qQ][rR][tT])
substr    ([sS][uU][bB][sS][tT][rR])
sysdate    ([sS][yY][sS][dD][aA][tT][eE])
sys_extract_utc    ([sS][yY][sS]_[eE][xX][tT][rR][aA][cC][tT]_[uU][tT][cC])
systimestamp    ([sS][yY][sS][tT][iI][mM][eE][sS][tT][aA][mM][pP])
tan    ([tT][aA][nN])
tanh    ([tT][aA][nN][hH])
timestamp_to_scn    ([tT][iI][mM][eE][sS][tT][aA][mM][pP]_[tT][oO]_[sS][cC][nN])
to_binary_double    ([tT][oO]_[bB][iI][nN][aA][rR][yY]_[dD][oO][uU][bB][lL][eE])
to_binary_float    ([tT][oO]_[bB][iI][nN][aA][rR][yY]_[fF][lL][oO][aA][tT])
to_char    ([tT][oO]_[cC][hH][aA][rR])
to_clob    ([tT][oO]_[cC][lL][oO][bB])
to_date    ([tT][oO]_[dD][aA][tT][eE])
to_dsinterval    ([tT][oO]_[dD][sS][iI][nN][tT][eE][rR][vV][aA][lL])
to_lob    ([tT][oO]_[lL][oO][bB])
to_multi_byte    ([tT][oO]_[mM][uU][lL][tT][iI]_[bB][yY][tT][eE])
to_nchar    ([tT][oO]_[nN][cC][hH][aA][rR])
to_nclob    ([tT][oO]_[nN][cC][lL][oO][bB])
to_number    ([tT][oO]_[nN][uU][mM][bB][eE][rR])
to_single_byte    ([tT][oO]_[sS][iI][nN][gG][lL][eE]_[bB][yY][tT][eE])
to_timestamp    ([tT][oO]_[tT][iI][mM][eE][sS][tT][aA][mM][pP])
to_timestamp_tz    ([tT][oO]_[tT][iI][mM][eE][sS][tT][aA][mM][pP]_[tT][zZ])
to_yminterval    ([tT][oO]_[yY][mM][iI][nN][tT][eE][rR][vV][aA][lL])
translate    ([tT][rR][aA][nN][sS][lL][aA][tT][eE])
treat    ([tT][rR][eE][aA][tT])
trim    ([tT][rR][iI][mM])
trunc    ([tT][rR][uU][nN][cC])
tz_offset    ([tT][zZ]_[oO][fF][fF][sS][eE][tT])
unistr    ([uU][nN][iI][sS][tT][rR])
upper    ([uU][pP][pP][eE][rR])
using    ([uU][sS][iI][nN][gG])
width_bucket    ([wW][iI][dD][tT][hH]_[bB][uU][cC][kK][eE][tT])
funcname        {decode}|{abs}|{acos}|{add_months}|{asciistr}|{asin}|{atan}|{atan2}|{bin_to_num}|{bitand}|{cardinality}|{cast}|{ceil}|{chartorowid}|{chr}|{cluster_id}|{cluster_probability}|{cluster_set}|{collect}|{compose}|{concat}|{convert}|{cos}|{cosh}|{decompose}|{exp}|{feature_id}|{feature_set}|{feature_value}|{floor}|{from_tz}|{greatest}|{hextoraw}|{initcap}|{last_day}|{least}|{ln}|{localtimestamp}|{log}|{lower}|{lpad}|{ltrim}|{mod}|{months_between}|{nanvl}|{new_time}|{next_day}|{nls_charset_decl_len}|{nls_charset_id}|{nls_charset_name}|{nls_initcap}|{nls_lower}|{nlssort}|{nls_upper}|{numtodsinterval}|{numtoyminterval}|{power}|{powermultiset}|{powermultiset_by_cardinality}|{prediction}|{prediction_bounds}|{prediction_cost}|{prediction_details}|{prediction_probability}|{prediction_set}|{rawtohex}|{rawtonhex}|{regexp_replace}|{regexp_substr}|{remainder}|{replace}|{round}|{rowidtochar}|{rowidtonchar}|{rpad}|{rtrim}|{scn_to_timestamp}|{sessiontimezone}|{set}|{sign}|{sin}|{sinh}|{soundex}|{sqrt}|{substr}|{sys_extract_utc}|{tan}|{tanh}|{timestamp_to_scn}|{to_binary_double}|{to_binary_float}|{to_char}|{to_clob}|{to_date}|{to_dsinterval}|{to_lob}|{to_multi_byte}|{to_nchar}|{to_nclob}|{to_number}|{to_single_byte}|{to_timestamp}|{to_timestamp_tz}|{to_yminterval}|{translate}|{treat}|{trim}|{trunc}|{tz_offset}|{unistr}|{upper}|{width_bucket}

sfuncname       {current_date}|{current_timestamp}|{sysdate}|{systimestamp}|{dbtimezone}
sum             ([Ss][Uu][Mm])
avg             ([Aa][Vv][Gg])
max             ([Mm][Aa][Xx])
min             ([Mm][Ii][Nn])
count           ([cC][Oo][Uu][Nn][Tt])
aggregate	{sum}|{avg}|{min}|{max}|{count}

number 		[0-9]+(\.[0-9]+)?
quote		'
escapequote	{quote}{quote}
anyword		[0-9a-zA-Z]
val		('[^']*')
ident_start             [A-Za-z\200-\377_]
ident_cont              [A-Za-z\200-\377_0-9\$]
identifier              {ident_start}{ident_cont}*
dot	                 \.
space		[ \t\n\r\f]
comment         ("--"{non_newline}*)
non_newline     [^\n\r]
whitespace      ({space}+|"--"{non_newline}*)

st		([sS][eE][lL][Ee][cC][Tt])
fm		([fF][rR][oO][mM])
full            ([fF][uU][lL][lL])
outer           ([oO][uU][tT][eE][rR])
inner           ([iI][nN][nN][eE][rR])
join            ([jJ][oO][iI][nN])
left            ([lL][eE][fF][tT])
right           ([rR][iI][gG][hH][tT])
wh		([wW][hH][Ee][Rr][Ee])
gy		([Gg][Rr][Oo][Uu][pP])
oy		([Oo][Rr][Dd][Ee][Rr])
by		([Bb][Yy])
asc		([Aa][Ss][Cc])
desc		([dD][Ee][Ss][Cc])
having		([hH][aA][vV][Ii][nN][Gg])
is		([iI][sS])
null	        ([nN][uU][lL][lL])
tr		([tT][rR][Uu][Ee])
fa		([fF][Aa][Ll][Ss][eE])
distinct	([Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt])
any		([aA][nN][yY])
some		([sS][oO][mM][eE])
all		([Aa][lL][lL])
uni		([uU][Nn][Ii][Qq][Uu][Ee])
union           ([uU][nN][iI][oO][nN])
to              ([tT][oO])
between         ([bB][eE][Tt][Ww][Ee][Ee][Nn])
not             ([nN][Oo][Tt])
and             ([Aa][Nn][Dd])
or              ([oO][Rr])
in              ([Ii][Nn])
like            ([Ll][Ii][Kk][Ee])
escape          ([Ee][Ss][Cc][Aa][Pp][Ee])
exists          ([Ee][Xx][Ii][Ss][Tt][Ss])
on              ([oO][nN])
colon_equals    ":="
terminator	[;]
define		([Aa][sS])
self			[,()\[\].\:\+\-\*\/\%\^\<\>\=]
op_chars                [\~\!\@\#\^\&\|\`\?\+\-\*\/\%\<\>\=]
operator                {op_chars}+
singleword	[,()\[\].\:\+\-\*\/\%\^\<\>\=]
hint_start      ([\/][\*])
hint_end        ([\*][\*])
allres          ([aA][lL][lL][rR][eE][sS])
someres         ([sS][oO][mM][eE][rR][eE][sS])
hashtb          ([hH][aS][sS][hH][tT][bB])
alltb           ([aA][lL][lL][tT][bB])
nomovetb        ([nN][oO][mM][oO][vV][eE][tT][bB])
nevermovetb     ([nN][eE][vV][eE][rR][mM][oO][vV][eE][tT][bB]) 
limit           ([lL][iI][mM][iI][tT])
offset          ([oO][fF][fF][sS][eE][tT])
%%

{limit}  { 
    return LIMIT_C;
}

{offset}  { 
    return OFFSET_C;
}

{colon_equals}  { 
    return COLON_EQUALS;
}

{by} {
    return BY;
}

{aggregate} {
    return AGGREGATE;
}

{funcname} {
    return FUNCNAME;
}

{sfuncname} {
    return SFUNCNAME;
}

{extract} {
    return EXTRACT;
}

{val} {
    return VALUE;
}

{number} {
    return NUMBER;
}

{is} {
    return IS;
}

{null} {
    return NULL_P;
}

{tr} {
    return TRUE_P;
}

{to} {
    return TO;
}

{fa} {
    return FALSE_P;
}

{distinct} {
    return DISTINCT;
}

{exists} {
    return EXISTS;
}

{any} {
    return ANY;
}

{some} {
    return SOME;
}

{all} {
    return ALL;
}

{uni} {
    return UNIQUE;
}

{union} {
    return UNION;
}

{between} {
    return BETWEEN;
}

{not} {
    return NOT;
}

{and} {
    return AND;
}

{or}  {
    return OR;
}

{in} {
    return IN_P;
}

{like} {
    return LIKE;
}

{escape} {
    return ESCAPE;
}

{on} {
    return ON;
}

"*" {
    return '*';
}

{st} {
    return ST;
}

{fm} {
    return FROM;
}
{full} {
    return FULL;
}
{inner} {
    return INNER;
}
{outer} {
    return OUTER;
}
{join} {
    return JOIN;
}

{left} {
    return LEFT;
}

{right} {
    return RIGHT;
}

{wh} {
    return WHERE;
}

{gy} {
    return GROUP;
}

{oy} {
    return ORDER;
}

{asc} {
    return ASC;
}

{desc} {
    return DESC;
}

{define} {
    return AS;
}

{having} {
    return HAVING;
}

{using} {
    return USING;
}

{self} {
    return yytext[0];
}

{operator} {
    return Op;
}

{identifier} {
    yylval.str = new string(yytext, yyleng);
    return IDENT;
}

{terminator} {
    return TERMINATOR;
}

{whitespace}	;
%%
int yywrap(void)
{
    return 1;
}

void clearBuffer(void)
{
    yy_delete_buffer(YY_CURRENT_BUFFER);
    yy_init = 1;
}
