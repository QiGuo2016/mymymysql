#ifndef WDY_1920382934_FILE
#define WDY_1920382934_FILE
#include <fstream>
#include <string>
#include <unordered_map>
#include <unordered_set>

namespace PageDB {
    struct Page;
    const int PAGE_SIZE = 8192;
    const int MaxPage = 2046;
    const int MagicNumber = 0x19941102;
    const int MagicNumberOffset = 0;
    const int EntryPageOffset = MagicNumberOffset + 4;
    const int PageCountOffset = EntryPageOffset + 2;
    const int PageMapOffset = PageCountOffset + 2;
    struct File {
        std::fstream raw;
        int entryPageID;
        std::unordered_map<int, int> pageMap;
        int pageOffset(int vaddr);
        int newPage();
        void writebackFileHeader();
        File(const std::string&);
        Page* loadPage(int page_id);
        void writePage(int page_id, Page* pg);
        ~File() {
            raw.close();
        }
    private:
        void initFile();
        void readFile();
    };
}
#endif