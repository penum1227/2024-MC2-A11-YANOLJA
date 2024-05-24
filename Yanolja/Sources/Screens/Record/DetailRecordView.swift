//
//  DetailRecordView.swift
//  Yanolja
//
//  Created by 박혜운 on 5/13/24.
//  Copyright © 2024 com.mc2.yanolja. All rights reserved.
//

import SwiftUI

// 내가 보이는 뷰를 생성하거나 편집하는 enum
enum RecordViewEditType {
  case create
  case edit
}

// MARK: - 고스트 꺼
struct DetailRecordView: View {
  @Environment (\.dismiss) var dismiss
  @State var recording: GameRecordModel = .init() // 수정할 때
  private let editType: RecordViewEditType
  private let changeRecords: ([GameRecordModel]) -> Void
  var recordUseCase: RecordUseCase
  
  init(
    to editType: RecordViewEditType,
    record: GameRecordModel = .init(),
    usecase: RecordUseCase,
    changeRecords: @escaping ([GameRecordModel]) -> Void
  ) {
    self.editType = editType
    self._recording = State(initialValue: record)
    self.recordUseCase = usecase
    self.changeRecords = changeRecords
  }
  
  let texts = ["a", "b", "c"]
  @State private var selected: String = "a"
  
  var body: some View {
    NavigationStack {
      List {
        Section(
          "직관 정보",
          content: {
            selectDate

              HStack(spacing: 10) {
                SelectTeamView(
                    type: .my,
                    selectedTeam: recording.myTeam,
                    
                    tappedAction: { selectedTeam in
                      recording.myTeam = selectedTeam
                    }
                )
                Text("VS")
                  .font(.title2)
                  .foregroundStyle(.gray)
                
                SelectTeamView(
                  type: .vs,
                  selectedTeam: recording.vsTeam,
                  tappedAction: { selectedTeam in
                    recording.vsTeam = selectedTeam
                  }
                )
              }
            
            // 경기장 Picker
            Picker(
              "경기장",
              selection: $recording.stadiums
            ) {
              ForEach(BaseballStadiums.allCases, id: \.self) {
                Text($0.name)
              }
            }
            .accentColor(.gray)
            .pickerStyle(.menu)
          }
        )
        // 직관 결과 선택 picker
        Picker("직관 결과", selection: $recording.result) {
          ForEach(GameResult.allCases, id: \.self) {
            Text($0.label)
          }
        }
        .pickerStyle(.inline)
        if editType == .edit {
          Button(
            action: {
              recordUseCase.effect(.tappedDeleteRecord(recording.id))
              changeRecords(recordUseCase.state.recordList)
              dismiss()
            },
            label: {
              HStack{
                Spacer()
                Text("기록 삭제").foregroundStyle(.red)
                Spacer()
              }
            }
          )
        }
      }
      .toolbar(
        content: {
          ToolbarItem(placement: .topBarTrailing) {
            Button(
              action: {
                if editType == .create { // 생성 시
                  recordUseCase.effect(.tappedSaveNewRecord(recording))
                  changeRecords(recordUseCase.state.recordList)
                } else { // 수정 시
                  recordUseCase.effect(.tappedEditNewRecord(recording))
                  changeRecords(recordUseCase.state.recordList)
                  dismiss()
                }
              },
              label: {
                Text("완료").bold()
              }
            )
          }
          ToolbarItem(placement: .topBarLeading) {
            Button(
              action: {
                if editType == .create { // 생성 시
                  recordUseCase.effect(.tappedCreateRecordSheet(false))
                } else { // 수정 시
                  recordUseCase.effect(.tappedRecordCellToEditRecordSheet(false))
                  dismiss()
                }
              },
              label: {
                Text("취소")
              }
            )
          }
        }
      )
      .padding(.horizontal, 10)
      .navigationTitle("오늘의 직관")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  var selectDate: some View {
    DatePicker(
      "날짜",
      selection: $recording.date,
      displayedComponents: [.date]
    )
  }
}

// 화면을 보이는 뷰
#Preview {
  DetailRecordView(
    // 현재 보여지는 뷰는 편집(삭제 버튼 추가)
    to: .edit,
    // usecase는 RecordUseCase를 사용
    usecase: RecordUseCase(dataService: CoreDataService()), changeRecords: { _ in }
  )
}
