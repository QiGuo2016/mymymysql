#include "scheduler.hpp"
#include <thread>
#include <chrono>

namespace PageDB {
    void Scheduler::ScheduleLoop() {
        while (running) {
            std::this_thread::sleep_for(SCHEDULE_LOOP_DELAY);
            Schedule();
        }
    }
    void Scheduler::StartSchedule() {
        if (!running) {
            running = true;
            ScheduleThread = std::thread([=](){this->ScheduleLoop();});
        }
    }
    void Scheduler::StopSchedule() {
        if (running) {
            running = false;
            ScheduleThread.join();
        }
    }
    File* Scheduler::OpenFile(const std::string& fn) {
        File*& file = fileIndex[fn];
        if (file == nullptr) {
            file = new File(fn);
        }
        return file;
    }
    PageDesc* Scheduler::GetPage(File* file, int page_id) {
        if (page_id < 0)
            return nullptr;
        PageDesc*& desc = pageIndex[std::make_pair(file, page_id)];
        if (desc == nullptr) {
            desc = new PageDesc(file, page_id);
        }
        return desc;
    }
    PageSession Scheduler::GetSession(File* file, int page_id) {
        return PageSession(GetPage(file, page_id));
    }
    PageWriteSession Scheduler::GetWriteSession(File* file, int page_id) {
        return PageWriteSession(GetPage(file, page_id));
    }
    Scheduler::~Scheduler() {
        for (auto item : pageIndex)
            delete item.second;
        for (auto item : fileIndex)
            delete item.second;
    }
}