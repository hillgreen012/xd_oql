#include <stdio.h>
#include <iostream>
#include <string>
#include <vector>
#include <set>

#include "YaccParam.hpp"
#include "SqlSyntax.hpp"

using namespace std;

typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char *yy_str);
extern void yy_switch_to_buffer(YY_BUFFER_STATE new_buffer);
extern int yyparse(YaccParam* yp);
extern void yy_delete_buffer(YY_BUFFER_STATE b);
extern void clearBuffer(void);

int parse(const char* sql, set<string>* tables, vector<string>* errmsgs) {
  YaccParam yp;
  yp.tables = tables;
  yp.errmsgs = errmsgs;
    
  void* bp = yy_scan_string(sql);
  yy_switch_to_buffer((YY_BUFFER_STATE)bp);
  int ret = yyparse(&yp);
  yy_delete_buffer((YY_BUFFER_STATE)bp);
  clearBuffer();

  return ret;
}

string getSql(istream& is) {
  string sql;
  string line;
  while (is && getline(is, line, '\n')) sql += line + '\n';
  return sql;
}

int main(int argc, char* argv[])
{
  set<string> tables;
  vector<string> errmsgs;

  string sql = getSql(cin);
  int result = parse(sql.c_str(), &tables, &errmsgs);

  if (!errmsgs.empty()) {
    cout << "[EXCEPTION] ";
    for (vector<string>::iterator it = errmsgs.begin(); it != errmsgs.end(); ++it) {
      cout << *it << " ";
    }
    cout << endl;
  }
  else if (!tables.empty()) { // for SOMETHING don't support db.table as table reference
    cout << "[OBJECT] ";
    for (set<string>::iterator it = tables.begin(); it != tables.end(); ++it) {
      cout << *it << " ";
    }
    cout << endl;
  }

  return 0;  // CAUTIONS: not result's value
}
