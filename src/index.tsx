import { NativeModules } from 'react-native';

type IosModalType = {
  multiply(a: number, b: number): Promise<number>;
};

const { IosModal } = NativeModules;

export default IosModal as IosModalType;
