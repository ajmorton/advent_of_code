cc_library(
    name = "solutions",
    hdrs = ["prelude.hpp", "day_01.hpp", "day_02.hpp", "day_03.hpp", "day_04.hpp", "day_05.hpp",
                           "day_06.hpp", "day_07.hpp", "day_08.hpp", "day_09.hpp"],
    srcs = ["prelude.cpp", "day_01.cpp", "day_02.cpp", "day_03.cpp", "day_04.cpp", "day_05.cpp",
                           "day_06.cpp", "day_07.cpp", "day_08.cpp", "day_09.cpp"],
    visibility = ["//:__pkg__", "//test:__pkg__"],
    deps = ["@boost//:conversion", "@boost//:algorithm", "@boost//:uuid"],
)