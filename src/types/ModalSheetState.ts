

export type ModalSheetState = 
  | 'presenting'
  | 'dismissViaGestureCancelling'
  | 'presented'
  | 'dismissViaGestureCancelled'
  | 'dismissing'
  | 'dismissingViaGesture'
  | 'presentingViaGestureCanceling'
  | 'dismissed'
  | 'dismissedViaGesture'
  | 'presentingViaGestureCancelled';