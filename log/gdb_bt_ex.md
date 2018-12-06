
# GDB BackTrace Example #
~~~

(gdb) bt

#0  inline std::allocator<char>::allocator(std::allocator<char> const&) ()
    at /opt/aCC/include_std/memory:252

#1  0x9fffffffbb8b7440:0 in inline std::basic_string<char,std::char_traits<char>,std::allocator<char> >::get_allocator() const ()
    at /opt/aCC/include_std/string:774

#2  0x9fffffffbb8b7420:0 in std::basic_string<char,std::char_traits<char>,std::allocator<char> >::basic_string (this=0x9fffffffffffdb58, __s=@0x0)
   at /opt/aCC/include_std/string:1035

#3  0x9fffffffbbbb2100:0 in nexcore::sql::Record::setValue (
    this=0x9fffffffffffdd30, key=@0x0, value=@0x9fffffffffffdca8)
    at nexcore/sql/Record.cpp:67
    
#4  0x9fffffffb99ec310:0 in int nexcore::sql::SqlManager::select<TestFun*,bool
    (this=0x600000000006d0c0, statementId=@0x9fffffffffffde00,
    params=0x9fffffffffffde30, c=0x60000000001340b0, mf=(bool ( class TestFun
    ::*)(class nexcore::sql::Record *...)) -147599808)
    at /home/jsh/nexbuild/nana/include/nexcore/sql/SqlManager.hpp:157
    
#5  0x9fffffffb99e9240:0 in TestFun::perform (this=0x60000000001340b0,
    request=0x6000000000141950, response=0x6000000000025840) at TestFun.cpp:103
    
#6  0x9fffffffbbc74510:2 in inline std::allocator<char>::allocator() ()
    at /opt/aCC/include_std/memory:250

   ~~~ 
   
   
   ## frame ##
   
   ~~~
   (gdb) f 4

#4  0x9fffffffb99ec310:0 in int nexcore::sql::SqlManager::select<TestFun*,bool

    (this=0x600000000006d0c0, statementId=@0x9fffffffffffde00,

    params=0x9fffffffffffde30, c=0x60000000001340b0, mf=(bool ( class TestFun

    ::*)(class nexcore::sql::Record *...)) -147599808)

    at /home/jsh/nexbuild/nana/include/nexcore/sql/SqlManager.hpp:157 
    157      record.setValue( colNames[i], rset->getString(i+1) );

   ~~~
   
   
