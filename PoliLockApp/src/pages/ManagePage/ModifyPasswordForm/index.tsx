import {
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import PasswordForm from "../../../components/PasswordForm";
import { create } from "ionicons/icons";

const ModifyPasswordForm: React.FC = () => {
  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("testando submit");
    console.log(data.senha);
  };

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle>Modificar Senha</IonCardTitle>
      </IonCardHeader>

      <IonCardContent>
        <PasswordForm
          onSubmit={onSubmit}
          submitBtnText="Mudar Senha"
          btnIcon={create}
          placeholder="Nova senha"
        />
      </IonCardContent>
    </IonCard>
  );
};

export default ModifyPasswordForm;
