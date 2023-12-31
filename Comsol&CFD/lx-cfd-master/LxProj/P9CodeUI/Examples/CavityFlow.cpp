#include "CavityFlow.h"
#include "FluentMesh.h"
#include "ExcuteSaveFile.h"
namespace LxCFD
{
    CavityFlow::CavityFlow(int ID, const std::string &fileFolder) : ExampleBase(ID, fileFolder)
    {
        Description = "方腔顶盖驱动流";
    }
    void CavityFlow::RunCase()
    {
        std::string fileName = "Case2-Cavity";
        try
        {
            //1.读取文件
            {
                FluentMesh fmesh;
                fmesh.ReadFile(FileFolder + fileName + ".msh");
            }
            AppRes::FvMesh->PrepareMeshData();
            {
                //2.设置物理模型
                auto physical = std::shared_ptr<PhysicalModel>(new PhysicalModel());
                physical->SetPhysicalType(PhysicalTypes::Fluid);
                physical->IsEnergyEnabled = false;
                AppRes::PhysicalCenter->PhysicalModels.push_back(physical);
                //3.设置边界条件
                FvZone &zone = FineZone("SOLID");
                zone.PhysicalModel = physical;

                FvThread &thread_UP = FindThread(zone, "UP");
                thread_UP.BoundaryType = BoundaryTypes::FluidWall;
                thread_UP.IsStaticWall = false;
                thread_UP.Velocity = std::unique_ptr<Value1Base<Vector3d>>(new Value1Const::Vector(Vector3d(1, 0, 0)));
                FvThread &thread_DOWN = FindThread(zone, "DOWN");
                thread_DOWN.BoundaryType = BoundaryTypes::FluidWall;
                FvThread &thread_LEFT = FindThread(zone, "LEFT");
                thread_LEFT.BoundaryType = BoundaryTypes::FluidWall;
                FvThread &thread_RIGHT = FindThread(zone, "RIGHT");
                thread_RIGHT.BoundaryType = BoundaryTypes::FluidWall;
                FvThread &thread_FRONT = FindThread(zone, "FRONT");
                thread_FRONT.BoundaryType = BoundaryTypes::Symmetry;
                FvThread &thread_BACK = FindThread(zone, "BACK");
                thread_BACK.BoundaryType = BoundaryTypes::Symmetry;
                //3.进行计算参数
                MultiThreads::SetThreadsCout(1);
                AppRes::StepsCenter->SteadyStep.MaxSteps = 300;
                //4.设置文件保存
                std::shared_ptr<ExcuteSaveFile> saveFileTask = std::shared_ptr<ExcuteSaveFile>(new ExcuteSaveFile());
                saveFileTask->FilePath = FileFolder + fileName + ".vtu";
                saveFileTask->ExportScalars = std::vector<ScalarTypes>{ScalarTypes::Temperature, ScalarTypes::Pressure,ScalarTypes::PressureCorrection,ScalarTypes::MassImbalance, ScalarTypes::Velocity};
                AppRes::ExcuteCenter->ExcuteAfterAll_Fixed.push_back(saveFileTask);
                //5.执行计算
                AppRes::ComputeTask->RunComputation();
            }
        }
        catch (std::exception &e)
        {
            LxConsole::Error(e.what());
            return;
        }
    }
}