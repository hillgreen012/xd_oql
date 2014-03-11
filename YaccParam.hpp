////////////////////////////////////////////////////
///
///@file       : YaccParam.h
///@brief      : 
///
///@author     : Li Jingang<lijg@sugon.com>
///@date       : Fri Nov  2 15:27:50 2012
///@history    : 
///
///
///@description: 
///
///
/// Copyright (c) 2012, xData@Sugon, Inc.
///////////////////////////////////////////////////
#ifndef __YACCPARAM_H__
#define __YACCPARAM_H__
#include <set>
#include <string>

struct TableRef {
    std::string m_table;
    std::string m_alias;
    TableRef(const std::string& table, const std::string& alias = std::string("")):
        m_table(table),
        m_alias(alias) {
    }
};

struct YaccParam {
    std::set<std::string>* tables;
    std::vector<std::string>* errmsgs;
};
    
#endif
 
