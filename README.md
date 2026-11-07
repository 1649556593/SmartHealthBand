# SmartHealthBand

ESP32-S3 智能健康手环团队主工程。当前版本从正点原子 `01_lvgl_transplant` 例程复制，保留 RGB 屏、触摸与 LVGL 演示入口，作为可编译的硬件基础。原始例程未修改。

## 当前工程

- 目标芯片：ESP32-S3。
- 屏幕：正点原子 4.3 寸 RGB，例程支持 ID `0x4342`（480×272）和 `0x4384`（800×480）。实际屏幕型号需要核对。
- Flash：示例配置为 16 MB；PSRAM：示例配置为 Octal。使用前须与实物核对。
- LVGL：`main/idf_component.yml` 声明 `lvgl/lvgl: ^8.4.0`。首次构建需能获取该依赖。
- 入口：`main/main.c` 调用 `lvgl_demo()`。当前仍是厂商演示界面，尚未实现手环功能。

## 环境与构建

建议使用 ESP-IDF 5.3.5 的 ESP-IDF 命令提示符，进入本目录后运行：

```powershell
idf.py build
```

不要先运行 `idf.py set-target esp32s3`：现有 `sdkconfig` 已设置目标和屏幕所需选项，重新设置目标可能重置配置。构建成功后，再核对串口与硬件连接，并决定是否烧录。不要在未核对屏幕型号、Flash 和 PSRAM 之前烧录。

## 目录

```text
SmartHealthBand/
├── CMakeLists.txt
├── sdkconfig
├── partitions-16MiB.csv
├── main/                 # 当前演示入口和 LVGL 适配
├── components/BSP/       # 厂商 RGB 屏、触摸等驱动
└── docs/                 # 团队约定与后续集成记录
```

## 下一步

1. 验证 ESP-IDF 5.3.5 安装完成，并在本工程执行 `idf.py build`。
2. 核对开发板、屏幕、Flash/PSRAM 配置；在实物上验证 RGB 显示和触摸。
3. 定义 IMU、运动算法、久坐提醒、存储和 UI 的数据接口，再逐个增加组件。
4. 六人分工文档中写有 SPI 屏幕与 LVGL 8.3；本工程使用 RGB 屏及 LVGL 8.4，团队应统一按实际硬件和已验证的工程版本开发。

