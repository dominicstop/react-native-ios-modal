import type { ModalViewControllerMetrics } from "./ModalViewControllerMetrics";
import type { PresentationControllerMetrics } from "./PresentationControllerMetrics";


export type ModalMetrics = {
  modalViewControllerMetrics: ModalViewControllerMetrics;
  presentationControllerMetrics?: PresentationControllerMetrics;
}